import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../services/task_service.dart';

class AddTaskScreen extends StatefulWidget {
  final String token;

  const AddTaskScreen({super.key, required this.token});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _dueDate;
  bool _isSaving = false;

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

      await taskService.createTask(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
      );

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar tarefa: $error')));
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
                      'Adicionar tarefa',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const Text(
                      'Preencha os dados de sua nova tarefa',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
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
                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration('Descrição da tarefa'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.inputRadius,
                      ),
                      child: InputDecorator(
                        decoration: _inputDecoration('Data de vencimento'),
                        child: Text(
                          _dueDate == null
                              ? 'Data de vencimento'
                              : _formatDate(_dueDate!),
                          style: TextStyle(
                            color: _dueDate == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
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
                                'SALVAR TAREFA',
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
