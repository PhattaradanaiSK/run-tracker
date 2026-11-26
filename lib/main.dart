import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/app_config.dart';
import 'data/providers.dart';
import 'data/supabase/supabase_bootstrap.dart';

/// Starts the app.
///
/// When `SUPABASE_URL` and `SUPABASE_ANON_KEY` were supplied at build time
/// (`--dart-define-from-file=.env`), Supabase is initialized here, before
/// `runApp`, and the live repository is injected. Otherwise the app runs on
/// offline demo data. The key is never logged or rendered.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final backend = await initSupabaseBackend();

  if (config.hasSupabaseConfig && backend == null) {
    // Configured but unusable (bad key / offline): the app still starts and
    // uses offline demo data rather than blocking on a dead network.
    debugPrint(
      'Run Tracker: Supabase unavailable, running on offline demo data.',
    );
  }

  runApp(
    ProviderScope(
      overrides: <Override>[
        if (backend != null) supabaseBackendProvider.overrideWithValue(backend),
      ],
      child: const RunTrackerApp(),
    ),
  );
}
