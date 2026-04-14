import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFODivider extends StatelessWidget {
  const SFODivider({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? AppColors.darkBorder : AppColors.border,
    );
  }
}
