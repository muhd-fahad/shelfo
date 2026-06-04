import 'package:flutter/material.dart';

class SFOCard extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;

  const SFOCard({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = theme.cardTheme;

    return Material(
      color: cardTheme.color,
      shape: cardTheme.shape!,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
