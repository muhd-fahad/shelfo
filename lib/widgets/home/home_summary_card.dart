import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class HomeSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final String? badge;
  final Color? badgeColor;
  final Color? iconColor;
  final Color? iconBgColor;

  const HomeSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.badge,
    this.badgeColor,
    this.iconColor,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(
              color: theme.colorScheme.outlineVariant,
              width: 1,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),

                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (badgeColor ?? AppColors.primary).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badge!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: badgeColor ?? AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),


            Row(
              spacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: iconBgColor ?? AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 16,
                    color: iconColor ?? AppColors.primary,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
