import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

enum SFOSummaryType { primary, warning, error }

class SFOSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final SFOSummaryType type;

  const SFOSummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.type = SFOSummaryType.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    Color bgColor;
    Color textColor;
    IconData iconData;

    switch (type) {
      case SFOSummaryType.primary:
        bgColor = colorScheme.onSurface;
        textColor = colorScheme.surface;
        iconData = Icons.inventory_rounded;
        break;
      case SFOSummaryType.warning:
        bgColor = isDark ? const Color(0xFF451A03) : const Color(0xFFFFF7ED);
        textColor = isDark ? Colors.orangeAccent : Colors.orange.shade900;
        iconData = Icons.hourglass_bottom_rounded;
        break;
      case SFOSummaryType.error:
        bgColor = isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2);
        textColor = isDark ? Colors.redAccent : Colors.red.shade900;
        iconData = Icons.warning_rounded;
        break;
    }

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
            Row(
              spacing: AppSpacing.xs,
              children: [
                Icon(
                  iconData,
                  color: textColor,
                ),
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
          ],
        ),
      ),
    );
  }
}
