import 'package:flutter/material.dart';

import '../utils/theme/theme_constants.dart';

Widget sectionHeaderWidget(String title, bool isDark) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
    ),
  );
}