import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: AppRadius.md,
          child: Container(
            width: 56.r,
            height: 56.r,
            decoration: ShapeDecoration(
              color: isPrimary
                  ? colorScheme.primary
                  : colorScheme.surfaceContainerLow,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: isPrimary
                    ? BorderSide.none
                    : BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Icon(
              icon,
              color: isPrimary
                  ? colorScheme.onPrimary
                  : colorScheme.onSurface,
              size: 24.r,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
