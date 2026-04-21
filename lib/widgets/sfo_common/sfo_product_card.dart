import 'dart:io';
import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOProductCard extends StatelessWidget {
  final String name;
  final String? sku;
  final String price;
  final int stockCount;
  final String? imagePath;
  final bool isDark;
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
    required this.isDark,
    this.onTap,
    this.isSelected = false,
    this.showStatusDot = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          shadows: isDark ? [] : [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.1 : 0.05),
              blurRadius: isSelected ? 8 : 2,
              offset: const Offset(0, 1),
            ),
          ],
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.borderLight),
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
                width: .maxFinite,
                height: 140,
                clipBehavior: .antiAlias,
                decoration: ShapeDecoration(
                  color: isDark ? AppColors.darkBackground : AppColors.surface,
                  shape: const RoundedSuperellipseBorder(
                    borderRadius: AppRadius.md,
                  ),
                ),
                child: imagePath != null
                    ? (imagePath!.startsWith('assets/')
                        ? Image.asset(imagePath!, fit: BoxFit.contain)
                        : Image.file(File(imagePath!), fit: BoxFit.cover))
                    : Icon(Icons.inventory_2_outlined,
                        size: 32, color: AppColors.primary.withOpacity(0.2)),
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
                        style: TextStyle(
                          color: isDark ? AppColors.darkTextSecondary.withOpacity(0.6) : AppColors.textMuted,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Inter',
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
                        color: stockCount > 0 ? AppColors.success : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkBackground : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "$stockCount left",
                      style: TextStyle(
                        color: isDark ? AppColors.darkTextSecondary : const Color(0xFF475569),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
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
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
                  height: 1.3,
                ),
              ),

              Text(
                price,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
