import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class SFOChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  const SFOChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: ShapeDecoration(
          color: isSelected
              ? (isDark ? colorScheme.primary : AppColors.textPrimary)
              : (isDark ? AppColors.darkSurface : AppColors.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.border),
              width: 1,
            ),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppColors.white
                : (isDark ? AppColors.darkTextSecondary : AppColors.slate600),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
