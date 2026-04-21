import 'package:flutter/material.dart';
import '../../utils/theme/theme_constants.dart';

class SFOBadge extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color? textColor;

  const SFOBadge({
    super.key,
    required this.label,
    required this.bgColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: const RoundedSuperellipseBorder(
          borderRadius: AppRadius.pill,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor ?? AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
