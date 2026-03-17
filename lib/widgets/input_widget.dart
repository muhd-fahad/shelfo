import 'package:flutter/material.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final String hint;
  const InputWidget({super.key, required this.title, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .max,
      spacing: AppSpacing.xs,
      crossAxisAlignment: .start,
      children: [
        Text(title, style: SFOAppTheme.light.textTheme.labelMedium),
        TextField(
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
