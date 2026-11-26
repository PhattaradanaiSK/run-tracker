import '../models/run_entry.dart';

/// The only data contract the widgets are allowed to know about.
///
/// Widgets must never import Supabase or talk to HTTP directly: they depend on
/// this interface, and the app picks an implementation at startup.
abstract interface class RunRepository {
  /// All rows, newest first.
  Future<List<RunEntry>> listRuns();

  /// One row, or null when the id is unknown.
  Future<RunEntry?> getRun(String id);

  /// Inserts a new row and returns it (with the generated id / created_at).
  Future<RunEntry> createRun(RunDraft draft);

  /// Updates every editable column of an existing row.
  Future<RunEntry> updateRun(String id, RunDraft draft);

  /// Removes the row and any photo it owned.
  Future<void> deleteRun(String id);
}

/// Optional photo handling, kept separate from the row store.
///
/// The offline implementation copies a picked file into the app directory; the
/// Supabase implementation uploads to the `run_bk` bucket and deletes
/// replaced objects.
abstract interface class PhotoStore {
  /// Captures with the camera. Returns null when the user backs out or the
  /// camera is unavailable on this device.
  Future<String?> capturePhoto();

  /// Copies a newly captured temp file into durable local storage.
  Future<String> persistPhoto(String sourcePath);

  /// Deletes a previously persisted photo. Safe to call for unknown paths.
  Future<void> deletePhoto(String path);
}
