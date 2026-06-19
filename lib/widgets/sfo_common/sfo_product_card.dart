import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme/theme.dart';

class SFOProductCard extends StatelessWidget {
  final String name;
  final String? sku;
  final String price;
  final int stockCount;
  final String? imagePath;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showStatusDot;

  const SFOProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.stockCount,
    this.sku,
    this.imagePath,
    this.onTap,
    this.isSelected = false,
    this.showStatusDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: ShapeDecoration(
          color: theme.cardTheme.color,
          shadows: isDark ? [] : [
            BoxShadow(
              color: AppColors.black.withValues(alpha:isSelected ? 0.1 : 0.05),
              blurRadius: isSelected ? 8 : 2,
              offset: const Offset(0, 1),
            ),
          ],
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  width: double.maxFinite,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: isDark ? colorScheme.surface : colorScheme.surfaceContainerHighest,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: AppRadius.md,
                    ),
                  ),
                  child: imagePath != null
                      ? (imagePath!.startsWith('assets/')
                          ? Image.asset(imagePath!, fit: BoxFit.contain)
                          : (kIsWeb 
                              ? Image.network(imagePath!, fit: BoxFit.cover)
                              : Image.file(File(imagePath!), fit: BoxFit.cover)))
                      : Icon(Icons.inventory_2_outlined,
                          size: 32, color: colorScheme.primary.withValues(alpha:0.2)),
                ),
              ),
              SizedBox(height: AppSpacing.xs),

              // SKU and Status Dot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (sku != null)
                    Expanded(
                      child: Text(
                        sku!.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(alpha:0.6),
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  SizedBox(width: 4.w),
                  if (showStatusDot)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: stockCount > 0 ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  SizedBox(width: 4.w),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      "$stockCount",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Product Name
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
              
              const Spacer(),

              Text(
                price,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
