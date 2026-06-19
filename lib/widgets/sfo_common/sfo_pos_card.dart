import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme/theme.dart';

class SFOPosCard extends StatelessWidget {
  final String name;
  final String price;
  final int stockCount;
  final String? badgeText;
  final String? imagePath;
  final VoidCallback? onTap;
  final bool isSelected;

  const SFOPosCard({
    super.key,
    required this.name,
    required this.price,
    required this.stockCount,
    this.badgeText,
    this.imagePath,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic styles based on theme and state
    final Color currentBorderColor = isSelected 
        ? colorScheme.primary 
        : (isDark ? colorScheme.outline : AppColors.border);
    
    final Color currentImageBg = isSelected 
        ? (isDark ? AppColors.primaryDark.withValues(alpha: 0.2) : AppColors.primaryLight) 
        : (isDark ? colorScheme.surfaceContainer : AppColors.surface);
    
    final bool isWarning = stockCount == 0;
    final Color badgeBg = isWarning 
        ? (isDark ? AppColors.error.withValues(alpha: 0.2) : AppColors.errorLight) 
        : (isDark ? colorScheme.surfaceContainerHighest : AppColors.borderLight);
    
    final Color badgeTextColor = isWarning 
        ? (isDark ? AppColors.error : AppColors.error) 
        : (isDark ? colorScheme.onSurfaceVariant : AppColors.slate600);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: ShapeDecoration(
          color: isDark ? colorScheme.surface : AppColors.white,
          shadows: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(
              color: currentBorderColor,
              width: 1,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Container
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: ShapeDecoration(
                    color: currentImageBg,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: AppRadius.md,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imagePath != null
                      ? (imagePath!.startsWith('assets/')
                          ? Image.asset(imagePath!, fit: BoxFit.cover)
                          : (kIsWeb
                              ? Image.network(imagePath!, fit: BoxFit.cover)
                              : Image.file(File(imagePath!), fit: BoxFit.cover)))
                      : Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 32,
                            color: colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                ),
              ),
              SizedBox(height: AppSpacing.xs),

              // Product Name
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isDark ? colorScheme.onSurface : AppColors.textPrimary,
                ),
              ),
              
              const Spacer(),

              // Price and Badge Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      price,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.price.copyWith(
                        color: AppColors.primary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badgeText ?? "$stockCount",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: badgeTextColor,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
