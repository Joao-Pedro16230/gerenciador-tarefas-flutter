import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class RouterConfig {
  static GoRouter create({
    required WidgetBuilder login,
    required Widget Function(BuildContext context, GoRouterState state)
    dashboard,
    required Widget Function(BuildContext context, GoRouterState state) tasks,
    required Widget Function(BuildContext context, GoRouterState state) addTask,
    required Widget Function(BuildContext context, GoRouterState state)
    editTask,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.loginPath,
      routes: [
        GoRoute(
          path: AppRoutes.loginPath,
          name: AppRoutes.login,
          builder: (context, state) => login(context),
        ),
        GoRoute(
          path: AppRoutes.dashboardPath,
          name: AppRoutes.dashboard,
          builder: dashboard,
        ),
        GoRoute(
          path: AppRoutes.tasksPath,
          name: AppRoutes.tasks,
          builder: tasks,
        ),
        GoRoute(
          path: AppRoutes.addTaskPath,
          name: AppRoutes.addTask,
          builder: addTask,
        ),
        GoRoute(
          path: AppRoutes.editTaskPath,
          name: AppRoutes.editTask,
          builder: editTask,
        ),
      ],
    );
  }
}
