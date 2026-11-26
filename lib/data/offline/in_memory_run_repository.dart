import '../run_repository.dart';
import '../../models/run_entry.dart';

/// Local, network-free [RunRepository] backed by a map.
///
/// Used as offline demo data when no Supabase configuration is present, so the
/// app still works with no project and no connectivity.
class InMemoryRunRepository implements RunRepository {
  InMemoryRunRepository({
    List<RunEntry>? seed,
    this.idGenerator,
    this.clock,
  })  : _rows = <String, RunEntry>{
          for (final row in seed ?? const <RunEntry>[]) row.id: row,
        },
        _order = <String>[for (final row in seed ?? const <RunEntry>[]) row.id];

  final Map<String, RunEntry> _rows;

  /// Insertion order, which is the order the design's card list uses.
  final List<String> _order;

  /// Optional overrides for ids and timestamps.
  final String Function()? idGenerator;
  final DateTime Function()? clock;

  int _counter = 0;

  String _nextId() {
    if (idGenerator != null) return idGenerator!();
    _counter += 1;
    final stamp = (clock?.call() ?? DateTime.now()).microsecondsSinceEpoch;
    return 'run-$stamp-$_counter';
  }

  DateTime _now() => clock?.call() ?? DateTime.now();

  /// Rows in insertion (oldest-first) order, matching the design's list and
  /// the `run_tb` row order. The SQL side orders by `created_at` ascending.
  @override
  Future<List<RunEntry>> listRuns() async =>
      _order.map((id) => _rows[id]!).toList(growable: false);

  @override
  Future<RunEntry?> getRun(String id) async => _rows[id];

  @override
  Future<RunEntry> createRun(RunDraft draft) async {
    final entry = RunEntry(
      id: _nextId(),
      createdAt: _now(),
      runWhere: draft.runWhere.trim(),
      runPerson: draft.runPerson.trim(),
      runDistance: draft.runDistance,
      runImageUrl: draft.photoPath,
    );
    _rows[entry.id] = entry;
    _order.add(entry.id);
    return entry;
  }

  @override
  Future<RunEntry> updateRun(String id, RunDraft draft) async {
    final existing = _rows[id];
    if (existing == null) {
      throw StateError('ไม่พบข้อมูล:id=$id');
    }
    final updated = existing.copyWith(
      runWhere: draft.runWhere.trim(),
      runPerson: draft.runPerson.trim(),
      runDistance: draft.runDistance,
      // A null photoPath means "no new photo", so keep the stored one.
      runImageUrl: draft.photoPath ?? existing.runImageUrl,
    );
    _rows[id] = updated;
    return updated;
  }

  @override
  Future<void> deleteRun(String id) async {
    _rows.remove(id);
    _order.remove(id);
  }
}
