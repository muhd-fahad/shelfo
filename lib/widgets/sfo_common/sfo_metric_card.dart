import 'package:flutter/material.dart';

class SFOMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const SFOMetricCard({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: cardTheme.color,
        shape: cardTheme.shape!,
      ),
      child: Column(
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color ?? colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
