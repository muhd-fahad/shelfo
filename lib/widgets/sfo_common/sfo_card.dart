import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: padding,
      decoration: ShapeDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
