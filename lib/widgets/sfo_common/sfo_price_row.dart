import 'package:flutter/material.dart';

class SFOPriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isPrimary;

  const SFOPriceRow({
    super.key,
    required this.label,
    required this.value,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPrimary ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
