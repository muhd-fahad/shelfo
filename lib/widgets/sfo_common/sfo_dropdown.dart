import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/theme/theme.dart';

class SFODropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const SFODropdown({
    super.key,
    required this.label,
    this.value,
    this.hint,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
            children: isRequired
                ? [TextSpan(
                      text: ' *',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: ShapeDecoration(
            color: theme.inputDecorationTheme.fillColor,
            shape: RoundedSuperellipseBorder(
              borderRadius: AppRadius.md,
              side: BorderSide(
                color: colorScheme.outline,
              ),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              hint: hint != null ? Text(hint!, style: theme.inputDecorationTheme.hintStyle) : null,
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: colorScheme.onSurfaceVariant,
                size: 24.r,
              ),
              onChanged: onChanged,
              items: items,
              dropdownColor: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ],
    );
  }
}
