import 'package:flutter/material.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

class InvoicePreviewWidget extends StatelessWidget {
  const InvoicePreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedSuperellipseBorder(
        borderRadius: AppRadius.md,
        side: BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            Row(
              spacing: AppSpacing.sm,
              children: [
                Icon(
                  Icons.description_outlined,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
                Text("Preview", style: SFOAppTheme.light.textTheme.labelMedium),
              ],
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  spacing: AppSpacing.sm,
                  children: [
                    Row(
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        Text(
                          "Techno Mobiles",
                          style: SFOAppTheme.light.textTheme.titleMedium,
                        ),
                        Text(
                          "INV-1001",
                          style: SFOAppTheme.light.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Divider(color: AppColors.border),
                    Container(
                      height: 12,
                      margin: EdgeInsets.only(right: 80),
                      decoration: ShapeDecoration(
                        color: AppColors.borderLight,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: AppRadius.lg,
                        ),
                      ),
                    ),
                    Container(
                      height: 12,
                      margin: EdgeInsets.only(right: 120),
                      decoration: ShapeDecoration(
                        color: AppColors.borderLight,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: AppRadius.lg,
                        ),
                      ),
                    ),
                    Divider(color: AppColors.border),
                    Text(
                      'Thank you for your business!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        // color: const Color(0xFF9CA3AF),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
