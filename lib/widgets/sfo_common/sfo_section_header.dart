import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOSectionHeader extends StatelessWidget {
  final String title;

  const SFOSectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      ),
    );
  }
}
