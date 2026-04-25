import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

class SFOSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  final Color textColor;

  const SFOSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: bgColor,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(
              color: colorScheme.outline.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: textColor.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
