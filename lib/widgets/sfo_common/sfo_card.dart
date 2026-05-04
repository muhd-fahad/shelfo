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

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: cardTheme.color,
        shape: cardTheme.shape!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
