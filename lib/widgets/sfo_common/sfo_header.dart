import 'package:flutter/material.dart';

class SFOHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SFOHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final titleWidget = Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );

    if (subtitle == null) {
      return titleWidget;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget,
        const SizedBox(height: 2),
        Text(
          subtitle!,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
