import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class DashboardScreen extends StatefulWidget {
  final String token;

  const DashboardScreen({super.key, required this.token});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final TaskService _taskService;
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();

    _taskService = TaskService(token: widget.token);
    _tasksFuture = _taskService.getTasks();
  }

  Widget _buildCounterCard(String title, int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.counterLabel),
          const SizedBox(height: AppSpacing.sm),
          Text('$count', style: AppTextStyles.counterValue),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: FutureBuilder<List<Task>>(
                future: _tasksFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar tarefas: ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  final tasks = snapshot.data ?? [];

                  final total = tasks.length;

                  final completed = tasks
                      .where((task) => task.isCompleted)
                      .length;

                  final pending = total - completed;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Olá, usuário', style: AppTextStyles.dashboardTitle),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Organize suas tarefas e acompanhe seu progresso',
                        style: AppTextStyles.dashboardSubtitle,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildCounterCard('Total de tarefas', total),
                      const SizedBox(height: AppSpacing.md),
                      _buildCounterCard('Tarefas pendentes', pending),
                      const SizedBox(height: AppSpacing.md),
                      _buildCounterCard('Tarefas concluídas', completed),
                      const SizedBox(height: AppSpacing.xl),
                      SizedBox(
                        height: AppSpacing.xxl,
                        child: ElevatedButton(
                          onPressed: () {
                            context.goNamed(
                              AppRoutes.tasks,
                              extra: widget.token,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppSpacing.inputRadius,
                              ),
                            ),
                          ),
                          child: Text(
                            'VER MINHAS TAREFAS',
                            style: AppTextStyles.buttonText,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
