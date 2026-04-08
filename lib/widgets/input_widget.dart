import 'package:flutter/material.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType? keyboardType;

  const InputWidget({
    super.key,
    required this.title,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
