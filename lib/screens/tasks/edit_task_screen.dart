import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  final String token;
  final Task task;

  const EditTaskScreen({super.key, required this.token, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  DateTime? _dueDate;
  bool _isCompleted = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.task.title);

    _descriptionController = TextEditingController(
      text: widget.task.description ?? '',
    );

    _dueDate = widget.task.dueDate;
    _isCompleted = widget.task.isCompleted;
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final taskService = TaskService(token: widget.token);

      final updatedTask = Task(
        id: widget.task.id,
        userId: widget.task.userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        isCompleted: _isCompleted,
        createdAt: widget.task.createdAt,
        updatedAt: widget.task.updatedAt,
      );

      await taskService.updateTask(updatedTask);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar tarefa: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.inputRadius),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Editar tarefa',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Altere as informações de sua tarefa',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    const Text(
                      'Título da tarefa',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration('Título da tarefa'),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'Informe um título com pelo menos 2 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Descrição da tarefa',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration('Descrição da tarefa'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const Text(
                      'Data de vencimento',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.inputRadius,
                      ),
                      child: InputDecorator(
                        decoration: _inputDecoration('Data de vencimento'),
                        child: Text(
                          _dueDate == null
                              ? 'Selecionar data'
                              : _formatDate(_dueDate!),
                          style: TextStyle(
                            color: _dueDate == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Tarefa concluída',
                        style: TextStyle(color: AppColors.textPrimary),
                      ),
                      activeThumbColor: AppColors.primary,
                      value: _isCompleted,
                      onChanged: (value) {
                        setState(() {
                          _isCompleted = value;
                        });
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SizedBox(
                      height: AppSpacing.xxl,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveTask,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.inputRadius,
                            ),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator()
                            : const Text(
                                'SALVAR ALTERAÇÕES',
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
      ),
    );
  }
}
