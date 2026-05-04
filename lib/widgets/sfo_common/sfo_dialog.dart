import 'package:flutter/material.dart';
import 'sfo_button.dart';
import '../../utils/theme/theme.dart';

class SFODialog extends StatelessWidget {
  final String title;
  final String message;
  final String? primaryActionText;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionText;
  final VoidCallback? onSecondaryAction;
  final bool isDestructive;

  const SFODialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryActionText,
    this.onPrimaryAction,
    this.secondaryActionText,
    this.onSecondaryAction,
    this.isDestructive = false,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String message,
    String? primaryActionText,
    VoidCallback? onPrimaryAction,
    String? secondaryActionText,
    VoidCallback? onSecondaryAction,
    bool isDestructive = false,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => SFODialog(
        title: title,
        message: message,
        primaryActionText: primaryActionText,
        onPrimaryAction: onPrimaryAction,
        secondaryActionText: secondaryActionText,
        onSecondaryAction: onSecondaryAction,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lg),
      backgroundColor: colorScheme.surface,
      title: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      content: Text(message, style: theme.textTheme.bodyMedium),
      actionsPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      actions: [
        if (secondaryActionText != null)
          SFOButton(
            text: secondaryActionText!,
            type: SFOButtonType.text,
            onPressed: onSecondaryAction ?? () => Navigator.pop(context),
            width: 100,
          ),
        if (primaryActionText != null)
          SFOButton(
            text: primaryActionText!,
            onPressed: onPrimaryAction,
            isSecondary: isDestructive,
            width: 100,
          ),
      ],
    );
  }
}
