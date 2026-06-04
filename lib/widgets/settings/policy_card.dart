import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/policy/policy_model.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_card.dart';
import '../sfo_common/sfo_badge.dart';

class PolicyCard extends StatelessWidget {
  final Policy policy;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PolicyCard({
    super.key,
    required this.policy,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    IconData icon;
    Color iconColor;
    switch (policy.type) {
      case PolicyType.warranty:
        icon = Icons.verified_user_outlined;
        iconColor = Colors.blue;
        break;
      case PolicyType.returnPolicy:
        icon = Icons.replay_circle_filled_outlined;
        iconColor = Colors.orange;
        break;
      case PolicyType.service:
        icon = Icons.handyman_outlined;
        iconColor = Colors.green;
        break;
    }

    return SFOCard(
      padding: EdgeInsets.all(16.r),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, color: iconColor, size: 24.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          policy.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: onEdit,
                            icon: Icon(Icons.edit_outlined, size: 20.sp),
                            visualDensity: VisualDensity.compact,
                          ),
                          IconButton(
                            onPressed: onDelete,
                            icon: Icon(Icons.delete_outline, size: 20.sp, color: AppColors.error),
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    "${policy.durationDays} Days Duration",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    policy.description,
                    style: theme.textTheme.bodySmall,
                  ),
                  SizedBox(height: 12.h),
                  ...policy.conditions.take(2).map((condition) => Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 14.sp, color: AppColors.success),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                condition,
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11.sp),
                              ),
                            ),
                          ],
                        ),
                      )),
                  if (policy.conditions.length > 2)
                    Text(
                      "+ ${policy.conditions.length - 2} more conditions",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                  SizedBox(height: 12.h),
                  SFOBadge(
                    label: policy.isActive ? "Active" : "Inactive",
                    bgColor: (policy.isActive ? AppColors.success : AppColors.textMuted).withValues(alpha: 0.1),
                    textColor: policy.isActive ? AppColors.success : AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
