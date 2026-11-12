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
}
