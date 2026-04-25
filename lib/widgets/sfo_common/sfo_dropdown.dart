import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class SFODropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isRequired;

  const SFODropdown({
    super.key,
    required this.label,
    required this.value,
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
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
              isExpanded: true,
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: colorScheme.onSurfaceVariant,
              ),
              onChanged: onChanged,
              items: items,
              dropdownColor: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
