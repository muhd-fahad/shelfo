import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class SFOSnackbar {
  static void show(
    BuildContext context, {
    required String message,
    bool isError = false,
    SnackBarAction? action,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isError ? AppColors.white : colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isError 
            ? colorScheme.error 
            : colorScheme.primary,
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
