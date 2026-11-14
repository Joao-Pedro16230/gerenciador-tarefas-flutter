import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_strings.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class TasksScreen extends StatefulWidget {
  final String token;

  const TasksScreen({super.key, required this.token});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late final TaskService _taskService;
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();

    _taskService = TaskService(token: widget.token);
    _tasksFuture = _taskService.getTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = _taskService.getTasks();
    });
  }

  void _openAddTask() {
    context.goNamed(AppRoutes.addTask, extra: widget.token);
  }

  void _openEditTask(Task task) {
    context.goNamed(
      AppRoutes.editTask,
      extra: {'token': widget.token, 'task': task},
    );
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(AppStrings.deleteTaskTitle),
          content: Text('${AppStrings.deleteTaskQuestion} "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text(AppStrings.delete),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    try {
      await _taskService.deleteTask(task.id);

      if (!mounted) return;

      _refreshTasks();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.taskDeleted)));
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.deleteTaskError}: $error')),
      );
    }
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    VoidCallback? onPressed,
  }) {
    return SizedBox(
      width: 90,
      height: 34,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: color,
          disabledForegroundColor: AppColors.textPrimary,
          padding: EdgeInsets.zero,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),
        child: Text(label, style: AppTextStyles.taskActionButton),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(task.title, style: AppTextStyles.taskTitle),

          const SizedBox(height: AppSpacing.xs),

          Text(
            task.description?.isNotEmpty == true
                ? task.description!
                : AppStrings.noDescription,
            style: AppTextStyles.taskDescription,
          ),

          if (task.category != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              '${AppStrings.categoryPrefix}: '
              '${task.category!.name}',
              style: AppTextStyles.taskCategory,
            ),
          ],

          if (task.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: task.tags.map((tag) {
                return Chip(
                  label: Text(tag.name),
                  backgroundColor: AppColors.background,
                  labelStyle: AppTextStyles.taskChip,
                );
              }).toList(),
            ),
          ],

          if (task.dueDate != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${AppStrings.dueDatePrefix}: '
              '${task.dueDate!.day.toString().padLeft(2, '0')}/'
              '${task.dueDate!.month.toString().padLeft(2, '0')}/'
              '${task.dueDate!.year}',
              style: AppTextStyles.taskDate,
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildActionButton(
                label: task.isCompleted
                    ? AppStrings.completed
                    : AppStrings.pending,
                color: task.isCompleted
                    ? AppColors.completed
                    : AppColors.pending,
              ),
              _buildActionButton(
                label: AppStrings.edit,
                color: AppColors.edit,
                onPressed: () => _openEditTask(task),
              ),
              _buildActionButton(
                label: AppStrings.delete,
                color: AppColors.delete,
                onPressed: () => _deleteTask(task),
              ),
            ],
          ),
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    AppStrings.tasksTitle,
                    style: AppTextStyles.taskPageTitle,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  const Text(
                    AppStrings.tasksSubtitle,
                    style: AppTextStyles.taskPageSubtitle,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  Flexible(
                    fit: FlexFit.loose,
                    child: FutureBuilder<List<Task>>(
                      future: _tasksFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              '${AppStrings.tasksLoadError}: '
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final tasks = snapshot.data ?? [];

                        if (tasks.isEmpty) {
                          return const Center(child: Text(AppStrings.noTasks));
                        }

                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return _buildTaskCard(tasks[index]);
                          },
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  SizedBox(
                    height: AppSpacing.xxl,
                    child: ElevatedButton(
                      onPressed: _openAddTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            AppSpacing.inputRadius,
                          ),
                        ),
                      ),
                      child: const Text(
                        AppStrings.addTaskButton,
                        style: AppTextStyles.buttonText,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
