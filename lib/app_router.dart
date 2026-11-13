import 'package:go_router/go_router.dart';

import 'core/routes/app_routes.dart';
import 'models/task.dart';
import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/tasks/add_task_screen.dart';
import 'screens/tasks/edit_task_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.loginPath,
    routes: [
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboardPath,
        name: AppRoutes.dashboard,
        builder: (context, state) {
          final token = state.extra as String?;

          if (token == null || token.isEmpty) {
            return const LoginScreen();
          }

          return DashboardScreen(token: token);
        },
      ),
      GoRoute(
        path: AppRoutes.tasksPath,
        name: AppRoutes.tasks,
        builder: (context, state) {
          final token = state.extra as String?;

          if (token == null || token.isEmpty) {
            return const LoginScreen();
          }

          return TasksScreen(token: token);
        },
      ),
      GoRoute(
        path: AppRoutes.addTaskPath,
        name: AppRoutes.addTask,
        builder: (context, state) {
          final token = state.extra as String?;

          if (token == null || token.isEmpty) {
            return const LoginScreen();
          }

          return AddTaskScreen(token: token);
        },
      ),
      GoRoute(
        path: AppRoutes.editTaskPath,
        name: AppRoutes.editTask,
        builder: (context, state) {
          final data = state.extra;

          if (data is! Map<String, dynamic>) {
            return const LoginScreen();
          }

          final token = data['token'];
          final task = data['task'];

          if (token is! String || token.isEmpty || task is! Task) {
            return const LoginScreen();
          }

          return EditTaskScreen(token: token, task: task);
        },
      ),
    ],
  );
}
