import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
              color: AppColors.black.withOpacity(isSelected ? 0.1 : 0.05),
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
          padding: const EdgeInsets.all(13),
          child: Column(
            spacing: AppSpacing.xs,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              Container(
                width: double.maxFinite,
                height: 140,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: isDark ? colorScheme.surface : colorScheme.surfaceContainerHighest,
                  shape: const RoundedSuperellipseBorder(
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
                        size: 32, color: colorScheme.primary.withOpacity(0.2)),
              ),
              const SizedBox(height: AppSpacing.xs),

              // SKU and Status Dot
              Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (sku != null)
                    Expanded(
                      child: Text(
                        sku!.toUpperCase(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  if (showStatusDot)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: stockCount > 0 ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "$stockCount left",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              // Product Name
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 12,
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
              ),

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
