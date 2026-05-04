import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class SFOSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const SFOSearchBar({
    super.key,
    required this.onChanged,
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
            height: 48,
            decoration: ShapeDecoration(
              color: theme.inputDecorationTheme.fillColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(color: colorScheme.outline),
              ),
            ),
            child: TextField(
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: theme.inputDecorationTheme.hintStyle,
                prefixIcon: Icon(Icons.search, size: 20, color: colorScheme.onSurfaceVariant),
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
              color: theme.inputDecorationTheme.fillColor,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(color: colorScheme.outline),
              ),
            ),
            child: IconButton(
              icon: Icon(Icons.tune_rounded, size: 20, color: colorScheme.onSurface),
              onPressed: onFilterTap,
            ),
          ),
        ],
      ],
    );
  }
}
