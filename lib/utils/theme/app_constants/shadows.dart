import 'package:flutter/material.dart';
import 'colors.dart';

class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}
