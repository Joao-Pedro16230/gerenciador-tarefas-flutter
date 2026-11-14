import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  // Login
  static const TextStyle loginTitle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle loginSubtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
  );

  // Dashboard
  static const TextStyle dashboardTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle dashboardSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle counterLabel = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle counterValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Telas de tarefas
  static const TextStyle taskPageTitle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskPageSubtitle = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle taskTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskDescription = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );

  static const TextStyle taskCategory = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskDate = TextStyle(
    fontSize: 13,
    color: AppColors.textSecondary,
  );

  static const TextStyle taskChip = TextStyle(
    fontSize: 12,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskActionButton = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  // Campos dos formulários
  static const TextStyle taskFieldHint = TextStyle(
    color: AppColors.textSecondary,
  );

  static const TextStyle taskFieldLabel = TextStyle(
    color: AppColors.textPrimary,
  );

  static const TextStyle taskError = TextStyle(color: Colors.red);
}
