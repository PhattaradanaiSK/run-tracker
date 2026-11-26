import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'run_repository.dart';

/// Camera-backed [PhotoStore] used with offline demo data.
///
/// The camera call can be injected. When no camera exists on the device,
/// [capturePhoto] returns null and the form still works, because the photo
/// is optional.
class LocalPhotoStore implements PhotoStore {
  LocalPhotoStore({
    required this.directory,
    Future<String?> Function()? pickFromCamera,
  }) : _pickFromCamera = pickFromCamera ?? _defaultCameraPick;

  /// Where captured photos are copied to (app documents / cache dir).
  final Directory directory;
  final Future<String?> Function() _pickFromCamera;

  static Future<String?> _defaultCameraPick() async {
    final picker = ImagePicker();
    final shot = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1600,
    );
    return shot?.path;
  }

  @override
  Future<String?> capturePhoto() async {
    try {
      return await _pickFromCamera();
    } catch (_) {
      // No camera or a denied permission: keep the photo optional.
      return null;
    }
  }

  @override
  Future<String> persistPhoto(String sourcePath) async {
    if (!directory.existsSync()) {
      await directory.create(recursive: true);
    }
    final name = sourcePath.split(Platform.pathSeparator).last;
    final target = '${directory.path}${Platform.pathSeparator}'
        '${DateTime.now().microsecondsSinceEpoch}_$name';
    await File(sourcePath).copy(target);
    return target;
  }

  @override
  Future<void> deletePhoto(String path) async {
    try {
      final file = File(path);
      if (file.existsSync() && path.startsWith(directory.path)) {
        await file.delete();
      }
    } on FileSystemException {
      // Best effort: a missing photo must never block deleting a row.
    }
  }
}
