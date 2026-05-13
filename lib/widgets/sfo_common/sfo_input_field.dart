import 'package:flutter/material.dart';

class SFOInputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool isRequired;
  final String? Function(String?)? validator;

  const SFOInputField({
    super.key,
    required this.label,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.isRequired = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: colorScheme.error),
                    ),
                  ]
                : [],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
