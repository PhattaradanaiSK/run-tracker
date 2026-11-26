import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../run_repository.dart';
import 'supabase_config.dart';
import 'supabase_photo_store.dart';
import 'supabase_run_repository.dart';

/// Resolves a stored `runImageUrl` value into something displayable.
typedef PhotoUrlResolver = String? Function(String? stored);

/// The live Supabase wiring, held behind the same interfaces the widgets use.
class SupabaseBackend {
  const SupabaseBackend({
    required this.runRepository,
    required this.photoStore,
    required this.photoUrlResolver,
  });

  final RunRepository runRepository;
  final PhotoStore photoStore;
  final PhotoUrlResolver photoUrlResolver;
}

/// Prepares the Supabase backend, or returns null when it cannot be used.
///
/// Returns null when the `--dart-define` values are missing (so the app uses
/// offline demo data) and also when initialization fails, so a bad key or an
/// offline device falls back to demo data instead of crashing on launch.
///
/// Nothing here logs the URL or the key; only a redacted reason is recorded.
Future<SupabaseBackend?> initSupabaseBackend({
  SupabaseConfig? config,
}) async {
  final resolved = config ?? SupabaseConfig.fromEnvironment();
  if (!resolved.isComplete) {
    developer.log(
      'Supabase config absent: using offline demo data.',
    );
    return null;
  }

  try {
    await Supabase.initialize(
      url: resolved.url,
      anonKey: resolved.anonKey,
    );
  } catch (error) {
    // Deliberately no URL / key in the message.
    developer.log(
      'Supabase initialization failed: falling back to offline demo data.',
      error: error.runtimeType.toString(),
    );
    return null;
  }

  final client = Supabase.instance.client;
  final photos = SupabasePhotoStore(client: client);
  return SupabaseBackend(
    runRepository: SupabaseRunRepository(client, photos: photos),
    photoStore: photos,
    photoUrlResolver: photos.resolveUrl,
  );
}
