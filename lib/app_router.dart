import 'package:go_router/go_router.dart';

import 'core/routes/router_config.dart';
import 'models/task.dart';
import 'screens/login/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/tasks/tasks_screen.dart';
import 'screens/tasks/add_task_screen.dart';
import 'screens/tasks/edit_task_screen.dart';

class AppRouter {
  static final GoRouter router = RouterConfig.create(
    login: (context) => const LoginScreen(),

    dashboard: (context, state) {
      final token = state.extra as String?;

      if (token == null || token.isEmpty) {
        return const LoginScreen();
      }

      return DashboardScreen(token: token);
    },

    tasks: (context, state) {
      final token = state.extra as String?;

      if (token == null || token.isEmpty) {
        return const LoginScreen();
      }

      return TasksScreen(token: token);
    },

    addTask: (context, state) {
      final token = state.extra as String?;

      if (token == null || token.isEmpty) {
        return const LoginScreen();
      }

      return AddTaskScreen(token: token);
    },

    editTask: (context, state) {
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
  );
}
