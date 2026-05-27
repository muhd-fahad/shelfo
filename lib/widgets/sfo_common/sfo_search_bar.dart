import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme/theme.dart';

class SFOSearchBar extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final String hintText;

  const SFOSearchBar({
    super.key,
    this.onChanged,
    this.controller,
    this.onFilterTap,
    this.hintText = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48.h,
            decoration: ShapeDecoration(
              color: theme.inputDecorationTheme.fillColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(color: colorScheme.outline),
              ),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: theme.inputDecorationTheme.hintStyle,
                prefixIcon: Icon(Icons.search, size: 20.r, color: colorScheme.onSurfaceVariant),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                fillColor: Colors.transparent,
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          SizedBox(width: 12.w),
          Container(
            height: 48.r,
            width: 48.r,
            decoration: ShapeDecoration(
              color: theme.inputDecorationTheme.fillColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(color: colorScheme.outline),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.tune_rounded, size: 20.r, color: colorScheme.onSurface),
              onPressed: onFilterTap,
            ),
          ),
        ],
      ],
    );
  }
}
