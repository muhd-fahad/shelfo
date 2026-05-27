import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SFOMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const SFOMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: ShapeDecoration(
        color: cardTheme.color,
        shape: cardTheme.shape!,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color ?? colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
