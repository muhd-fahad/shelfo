import 'package:flutter/material.dart';

import '../utils/theme/theme_constants.dart';

Widget dividerWidget(bool isDark) {
  return Divider(
    height: 1,
    indent: 16,
    endIndent: 16,
    color: isDark ? AppColors.darkBorder : AppColors.border.withOpacity(0.5),
  );
}