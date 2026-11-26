import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../run_repository.dart';
import 'supabase_config.dart';

/// [PhotoStore] that uploads to the `run_bk` bucket.
class SupabasePhotoStore implements PhotoStore {
  SupabasePhotoStore({
    required this.client,
    Future<String?> Function()? pickFromCamera,
  }) : _pickFromCamera = pickFromCamera ?? _defaultCameraPick;

  final SupabaseClient client;
  final Future<String?> Function() _pickFromCamera;

  static Future<String?> _defaultCameraPick() async {
    final shot = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1600,
    );
    return shot?.path;
  }

  /// Object path inside run_bk. A leading folder keeps objects sortable and
  /// makes a future per-user prefix an easy policy change.
  static String objectPath(String localPath) {
    final name = localPath.split('/').last;
    return 'photos/${DateTime.now().millisecondsSinceEpoch}_$name';
  }

  @override
  Future<String?> capturePhoto() async {
    try {
      return await _pickFromCamera();
    } catch (_) {
      return null;
    }
  }

  /// Uploads the file and returns the object path stored in `runImageUrl`.
  ///
  /// A path (not a public URL) is stored so the bucket can stay private; see
  /// [resolveUrl] for turning it back into something displayable.
  @override
  Future<String> persistPhoto(String sourcePath) async {
    final objectKey = objectPath(sourcePath);
    await client.storage.from(SupabaseConfig.bucketName).upload(
          objectKey,
          File(sourcePath),
          fileOptions: const FileOptions(
            cacheControl: '3600',
            contentType: 'image/jpeg',
            upsert: false,
          ),
        );
    return objectKey;
  }

  @override
  Future<void> deletePhoto(String path) async {
    if (path.isEmpty || path.startsWith('assets/') || path.startsWith('/')) {
      // Local asset or local file: nothing to remove remotely.
      return;
    }
    await client.storage.from(SupabaseConfig.bucketName).remove(<String>[path]);
  }

  /// Display URL for a stored path, or null when the row has no photo.
  String? resolveUrl(String? stored) {
    if (stored == null || stored.isEmpty) return null;
    if (stored.startsWith('http')) return stored;
    return client.storage
        .from(SupabaseConfig.bucketName)
        .getPublicUrl(stored);
  }
}
