import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'ui/router/app_router.dart';

class RunTrackerApp extends ConsumerStatefulWidget {
  const RunTrackerApp({super.key, this.initialLocation = AppRoutes.splash});

  /// Starting route; defaults to the splash screen.
  final String initialLocation;

  @override
  ConsumerState<RunTrackerApp> createState() => _RunTrackerAppState();
}

class _RunTrackerAppState extends ConsumerState<RunTrackerApp> {
  late final GoRouter _router =
      buildRouter(initialLocation: widget.initialLocation);

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Run Tracker',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      routerConfig: _router,
    );
  }
}
