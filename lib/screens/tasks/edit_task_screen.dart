import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/app_validators.dart';
import '../../models/category.dart';
import '../../models/tag.dart';
import '../../models/task.dart';
import '../../services/category_service.dart';
import '../../services/tag_service.dart';
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

  late final Future<List<Category>> _categoriesFuture;
  late final Future<List<Tag>> _tagsFuture;

  int? _selectedCategoryId;
  final Set<int> _selectedTagIds = {};

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

    _selectedCategoryId = widget.task.categoryId;
    _selectedTagIds.addAll(widget.task.tags.map((tag) => tag.id));

    _categoriesFuture = CategoryService(token: widget.token).getCategories();

    _tagsFuture = TagService(token: widget.token).getTags();
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
      final selectedTags = await _tagsFuture;

      if (!mounted) return;

      final updatedTask = Task(
        id: widget.task.id,
        userId: widget.task.userId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _dueDate,
        isCompleted: _isCompleted,
        categoryId: _selectedCategoryId,
        tags: selectedTags
            .where((tag) => _selectedTagIds.contains(tag.id))
            .toList(),
        createdAt: widget.task.createdAt,
        updatedAt: widget.task.updatedAt,
      );

      await taskService.updateTask(updatedTask);

      if (!mounted) return;

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppStrings.updateTaskError}: $error')),
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

  Widget _buildCategoryField() {
    return FutureBuilder<List<Category>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            AppStrings.categoriesLoadError,
            style: TextStyle(color: Colors.red),
          );
        }

        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final categories = snapshot.data!;

        return DropdownButtonFormField<int>(
          initialValue: _selectedCategoryId,
          dropdownColor: AppColors.inputBackground,
          decoration: _inputDecoration(AppStrings.category),
          hint: const Text(AppStrings.selectCategory),
          items: categories.map((category) {
            return DropdownMenuItem<int>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value;
            });
          },
        );
      },
    );
  }

  Widget _buildTagsField() {
    return FutureBuilder<List<Tag>>(
      future: _tagsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text(
            AppStrings.tagsLoadError,
            style: TextStyle(color: Colors.red),
          );
        }

        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        }

        final tags = snapshot.data!;

        if (tags.isEmpty) {
          return const Text(
            AppStrings.noTags,
            style: TextStyle(color: AppColors.textSecondary),
          );
        }

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: tags.map((tag) {
            return FilterChip(
              label: Text(tag.name),
              selected: _selectedTagIds.contains(tag.id),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTagIds.add(tag.id);
                  } else {
                    _selectedTagIds.remove(tag.id);
                  }
                });
              },
            );
          }).toList(),
        );
      },
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
                      AppStrings.editTaskTitle,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    const Text(
                      AppStrings.editTaskSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xxl),

                    const Text(
                      AppStrings.taskTitle,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    TextFormField(
                      controller: _titleController,
                      decoration: _inputDecoration(AppStrings.taskTitle),
                      validator: AppValidators.validateTaskTitle,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      AppStrings.taskDescription,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    TextFormField(
                      controller: _descriptionController,
                      decoration: _inputDecoration(AppStrings.taskDescription),
                      maxLines: 3,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      AppStrings.dueDate,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    InkWell(
                      onTap: _selectDate,
                      borderRadius: BorderRadius.circular(
                        AppSpacing.inputRadius,
                      ),
                      child: InputDecorator(
                        decoration: _inputDecoration(AppStrings.dueDate),
                        child: Text(
                          _dueDate == null
                              ? AppStrings.selectDate
                              : _formatDate(_dueDate!),
                          style: TextStyle(
                            color: _dueDate == null
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      AppStrings.category,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    _buildCategoryField(),

                    const SizedBox(height: AppSpacing.md),

                    const Text(
                      AppStrings.tags,
                      style: TextStyle(color: AppColors.textPrimary),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    _buildTagsField(),

                    const SizedBox(height: AppSpacing.lg),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        AppStrings.completedTask,
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
                                AppStrings.saveChanges,
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
