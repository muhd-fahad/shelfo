import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';

class ReportMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? trend;
  final IconData icon;
  final Color iconColor;

  const ReportMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return SFOCard(
      padding: EdgeInsets.all(12.r),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
            if (trend != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: trend == "Ok" ? colorScheme.outlineVariant : AppColors.successLight,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Row(
                  children: [
                    if (trend != "Ok")
                      Icon(Icons.arrow_upward, color: AppColors.success, size: 10.sp),
                    SizedBox(width: 2.w),
                    Text(
                      trend!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: trend == "Ok" ? colorScheme.onSurfaceVariant : AppColors.success,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const Spacer(),
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(fontSize: 10.sp),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
        if (subtitle != null) ...[
          SizedBox(height: 2.h),
          Text(
            subtitle!,
            style: theme.textTheme.labelSmall?.copyWith(fontSize: 9.sp),
          ),
        ],
      ],
    );
  }
}
