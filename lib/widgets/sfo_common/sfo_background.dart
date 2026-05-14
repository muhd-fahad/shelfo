import 'package:flutter/material.dart';

class SFOBackground extends StatelessWidget {
  final Widget child;

  const SFOBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                  theme.colorScheme.surface,
                ],
                stops: const [0.0, 0.5],
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
