import 'package:flutter/material.dart';

import '../../utils/theme/theme_constants.dart';

Widget settingsCardWidget(List<Widget> children, bool isDark) {
  return Container(
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
