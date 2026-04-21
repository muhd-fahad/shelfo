import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOPriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isPrimary;

  const SFOPriceRow({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isPrimary ? AppColors.primary : (isDark ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }
}
