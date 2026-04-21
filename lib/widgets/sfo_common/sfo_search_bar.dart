import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final bool isDark;
  final String hintText;

  const SFOSearchBar({
    super.key,
    required this.onChanged,
    this.onFilterTap,
    required this.isDark,
    this.hintText = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: ShapeDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
            ),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                prefixIcon: Icon(Icons.search, size: 20, color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                fillColor: Colors.transparent,
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 12),
          Container(
            height: 48,
            width: 48,
            decoration: ShapeDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.border),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.tune_rounded, size: 20, color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
              onPressed: onFilterTap,
            ),
          ),
        ],
      ],
    );
  }
}
