import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
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

  Future<void> _openAddTask() async {
    final result = await context.pushNamed<bool>(
      AppRoutes.addTask,
      extra: widget.token,
    );

    if (!mounted) return;

    if (result == true) {
      _refreshTasks();
    }
  }

  Future<void> _openEditTask(Task task) async {
    final result = await context.pushNamed<bool>(
      AppRoutes.editTask,
      extra: {'token': widget.token, 'task': task},
    );

    if (!mounted) return;

    if (result == true) {
      _refreshTasks();
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir tarefa'),
          content: Text('Deseja realmente excluir a tarefa "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Excluir'),
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

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarefa excluída com sucesso!')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao excluir tarefa: $error')));
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
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
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
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            task.description?.isNotEmpty == true
                ? task.description!
                : 'Sem descrição',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              _buildActionButton(
                label: task.isCompleted ? 'Concluída' : 'Pendente',
                color: task.isCompleted
                    ? AppColors.completed
                    : AppColors.pending,
              ),
              _buildActionButton(
                label: 'Editar',
                color: AppColors.edit,
                onPressed: () => _openEditTask(task),
              ),
              _buildActionButton(
                label: 'Excluir',
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
                    'Minhas Tarefas',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Organize e acompanhe suas atividades',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
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
                              'Erro ao carregar tarefas: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        final tasks = snapshot.data ?? [];

                        if (tasks.isEmpty) {
                          return const Center(
                            child: Text('Nenhuma tarefa cadastrada.'),
                          );
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
                        '+ ADICIONAR TAREFA',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
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
