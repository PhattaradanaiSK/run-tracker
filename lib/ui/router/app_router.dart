import 'package:go_router/go_router.dart';

import '../screens/add_run_ui.dart';
import '../screens/show_all_run_ui.dart';
import '../screens/splash_screen_ui.dart';
import '../screens/update_delete_run_ui.dart';

/// Route paths, kept in one place so screens agree on the same values.
abstract final class AppRoutes {
  const AppRoutes._();

  static const String splash = '/';
  static const String showAll = '/runs';
  static const String add = '/runs/add';
  static const String edit = '/runs/edit';

  static String editFor(String id) => '$edit/$id';
}

GoRouter buildRouter({String initialLocation = AppRoutes.splash}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreenUi(),
      ),
      GoRoute(
        path: AppRoutes.showAll,
        builder: (context, state) => const ShowAllRunUi(),
        routes: <RouteBase>[
          GoRoute(
            path: 'add',
            builder: (context, state) => const AddRunUi(),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) =>
                UpdateDeleteRunUi(runId: state.pathParameters['id'] ?? ''),
          ),
        ],
      ),
    ],
  );
}
