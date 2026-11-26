import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_config.dart';
import '../models/run_entry.dart';
import 'local_photo_store.dart';
import 'offline/in_memory_run_repository.dart';
import 'offline/seed_runs.dart';
import 'run_repository.dart';
import 'supabase/supabase_bootstrap.dart';

/// Compile-time config (dart-define only, never a committed key).
final appConfigProvider =
    Provider<AppConfig>((ref) => AppConfig.fromEnvironment());

/// The live Supabase backend, or null when the app should use offline demo data.
///
/// `main` calls `initSupabaseBackend()` and injects the result here. When this
/// stays null, the data providers below resolve to the in-memory repository.
final supabaseBackendProvider = Provider<SupabaseBackend?>((ref) => null);

/// The single data seam every screen uses.
///
/// Uses Supabase when a backend was initialized (URL + anon key present at
/// build time and `Supabase.initialize` succeeded); otherwise uses the
/// in-memory repository with offline demo data. Widgets never know which one
/// they got.
final runRepositoryProvider = Provider<RunRepository>((ref) {
  final backend = ref.watch(supabaseBackendProvider);
  if (backend != null) return backend.runRepository;
  return InMemoryRunRepository(seed: buildSeedRuns());
});

/// Photo store seam: the `run_bk` uploader when live, a local file copy
/// otherwise.
final photoStoreProvider = Provider<PhotoStore>((ref) {
  final backend = ref.watch(supabaseBackendProvider);
  if (backend != null) return backend.photoStore;

  final dir = Directory.systemTemp.createTempSync('runtracker_photos_');
  return LocalPhotoStore(directory: dir);
});

/// Turns a stored `runImageUrl` into something [Image.network] can load.
///
/// Null for offline demo data: stored values there are already local asset
/// paths or local file paths, so no transformation is needed.
final photoUrlResolverProvider = Provider<PhotoUrlResolver?>((ref) {
  return ref.watch(supabaseBackendProvider)?.photoUrlResolver;
});

/// Reactive list of runs for the Show all screen.
final runListProvider =
    AsyncNotifierProvider<RunListNotifier, List<RunEntry>>(RunListNotifier.new);

class RunListNotifier extends AsyncNotifier<List<RunEntry>> {
  @override
  Future<List<RunEntry>> build() => ref.watch(runRepositoryProvider).listRuns();

  Future<void> refresh() async {
    state = const AsyncValue<List<RunEntry>>.loading();
    state = await AsyncValue.guard(
      () => ref.read(runRepositoryProvider).listRuns(),
    );
  }
}

/// One run by id, used by the edit screen.
final runByIdProvider =
    FutureProvider.autoDispose.family<RunEntry?, String>((ref, id) {
  return ref.watch(runRepositoryProvider).getRun(id);
});
