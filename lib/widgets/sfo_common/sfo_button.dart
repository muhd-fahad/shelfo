import 'package:flutter/material.dart';
import '../../utils/theme/theme.dart';

enum SFOButtonType { filled, outlined, text }

class SFOButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final SFOButtonType type;
  final bool isLoading;
  final double? width;
  final bool isSecondary;
  final Color? backgroundColor;
  final bool iconTrailing;

  const SFOButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.type = SFOButtonType.filled,
    this.isLoading = false,
    this.width,
    this.isSecondary = false,
    this.backgroundColor,
    this.iconTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget child;
    if (isLoading) {
      child = SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
        ),
      );
    } else {
      final List<Widget> children = [
        if (icon != null && !iconTrailing) ...[
          Icon(icon, size: 20),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text),
        if (icon != null && iconTrailing) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, size: 20),
        ],
      ];
      child = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      );
    }

    final buttonWidth = width ?? double.infinity;

    switch (type) {
      case SFOButtonType.filled:
        return FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor ?? (isSecondary ? colorScheme.secondary : colorScheme.primary),
            minimumSize: Size(buttonWidth, 52),
          ),
          child: child,
        );
      case SFOButtonType.outlined:
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(buttonWidth, 52),
          ),
          child: child,
        );
      case SFOButtonType.text:
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: width != null ? Size(width!, 40) : null,
          ),
          child: child,
        );
    }
  }
}
