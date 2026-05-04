import 'package:flutter/material.dart';

class SFODivider extends StatelessWidget {
  const SFODivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: theme.colorScheme.outline,
    );
  }
}
