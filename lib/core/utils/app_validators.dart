import '../constants/app_strings.dart';

class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value.trim())) {
      return AppStrings.emailInvalid;
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }

    return null;
  }

  static String? validateTaskTitle(String? value) {
    if (value == null || value.trim().length < 2) {
      return AppStrings.taskTitleInvalid;
    }

    return null;
  }
}
