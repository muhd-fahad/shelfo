import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme/theme.dart';

class SFOBadge extends StatelessWidget {
  final String label;
  final Color? bgColor;
  final Color? textColor;

  const SFOBadge({
    super.key,
    required this.label,
    this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: bgColor ?? colorScheme.surfaceContainer,
        shape: const RoundedSuperellipseBorder(
          borderRadius: AppRadius.pill,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: textColor ?? colorScheme.onSurfaceVariant,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
