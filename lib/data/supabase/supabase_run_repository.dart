import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/run_entry.dart';
import '../run_repository.dart';
import 'supabase_config.dart';
import 'supabase_photo_store.dart';

/// [RunRepository] over the `public.run_tb` table.
///
/// The photo hand-off is explicit: [createRun] stores `draft.photoPath` as-is
/// in `runImageUrl`, and the caller uploads first (see [SupabasePhotoStore])
/// so a failed upload never leaves a row pointing at a missing object.
class SupabaseRunRepository implements RunRepository {
  SupabaseRunRepository(this.client, {SupabasePhotoStore? photos})
      : _photos = photos;

  final SupabaseClient client;
  final SupabasePhotoStore? _photos;

  static const String _table = SupabaseConfig.tableName;

  /// Column list kept in one place; camelCase identifiers stay quoted.
  static const String selectColumns =
      'id, created_at, "runWhere", "runPerson", "runDistance", "runImageUrl"';

  @override
  Future<List<RunEntry>> listRuns() async {
    final rows = await client
        .from(_table)
        .select(selectColumns)
        .order('created_at', ascending: true);
    return rows.map((row) => _fromRow(row)).toList(growable: false);
  }

  @override
  Future<RunEntry?> getRun(String id) async {
    final rows =
        await client.from(_table).select(selectColumns).eq('id', id).limit(1);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  @override
  Future<RunEntry> createRun(RunDraft draft) async {
    final inserted = await client
        .from(_table)
        .insert(<String, dynamic>{
          'runWhere': draft.runWhere.trim(),
          'runPerson': draft.runPerson.trim(),
          'runDistance': draft.runDistance,
          'runImageUrl': draft.photoPath,
        })
        .select(selectColumns)
        .single();
    return _fromRow(inserted);
  }

  @override
  Future<RunEntry> updateRun(String id, RunDraft draft) async {
    final patch = <String, dynamic>{
      'runWhere': draft.runWhere.trim(),
      'runPerson': draft.runPerson.trim(),
      'runDistance': draft.runDistance,
    };
    // A null photoPath means "keep the stored photo": the column is omitted
    // rather than set to null, so the old object stays referenced.
    if (draft.photoPath != null) {
      final previous = await getRun(id);
      final oldPath = previous?.runImageUrl;

      patch['runImageUrl'] = draft.photoPath;
      final updated = await client
          .from(_table)
          .update(patch)
          .eq('id', id)
          .select(selectColumns)
          .single();

      // New photo already uploaded by the caller: delete the replaced object.
      if (oldPath != null && oldPath != draft.photoPath && _photos != null) {
        await _photos.deletePhoto(oldPath);
      }
      return _fromRow(updated);
    }

    final updated = await client
        .from(_table)
        .update(patch)
        .eq('id', id)
        .select(selectColumns)
        .single();
    return _fromRow(updated);
  }

  @override
  Future<void> deleteRun(String id) async {
    // Read the row first so the Storage object can be removed after the delete.
    final existing = await getRun(id);
    await client.from(_table).delete().eq('id', id);
    final path = existing?.runImageUrl;
    if (path != null && path.isNotEmpty && _photos != null) {
      await _photos.deletePhoto(path);
    }
  }

  static RunEntry _fromRow(Map<String, dynamic> row) => RunEntry.fromJson(row);
}
