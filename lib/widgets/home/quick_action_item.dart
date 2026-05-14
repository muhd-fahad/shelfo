import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class QuickActionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const QuickActionItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: AppRadius.md,
            child: Container(
              width: 56,
              height: 56,
              decoration: ShapeDecoration(
                color: isPrimary
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurface : AppColors.white),
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppRadius.md,
                  side: isPrimary
                      ? BorderSide.none
                      : BorderSide(color: theme.colorScheme.outlineVariant),
                ),
              ),
              child: Icon(
                icon,
                color: isPrimary
                    ? AppColors.white
                    : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
