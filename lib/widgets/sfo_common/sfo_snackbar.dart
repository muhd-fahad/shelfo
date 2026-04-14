import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    SnackBarAction? action,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        backgroundColor: isError 
            ? Colors.redAccent 
            : (isDark ? AppColors.darkSurface : AppColors.primary),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(AppSpacing.lg),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.md),
        elevation: 4,
        action: action,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
