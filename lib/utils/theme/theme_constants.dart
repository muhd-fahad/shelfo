import 'package:flutter/material.dart';

/// ============================================================
/// DESIGN TOKENS
/// ============================================================

/// ---------------- COLORS ----------------
class AppColors {
  /// Brand
  static const Color primary =  Color(0xFF16A34A);
  static const Color primaryLight = Color(0xFFF0FDF4);
  static const Color primaryDark = Color(0xFF15803D);

  /// Light surfaces
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8FAFC);

  /// Dark surfaces
  static const Color darkBackground = Color(0xFF0B1220);
  static const Color darkSurface = Color(0xFF111827);

  /// Text light
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  /// Text dark
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFFCBD5F5);

  /// Borders
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color darkBorder = Color(0xFF1F2937);

  /// Status
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
}

/// ---------------- SPACING ----------------
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// ---------------- RADIUS ----------------
class AppRadius {
  static const BorderRadius sm = BorderRadius.all(Radius.circular(8));
  static const BorderRadius md = BorderRadius.all(Radius.circular(12));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(24));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}

/// ---------------- TEXT STYLES ----------------
class AppTextStyles {
  static const TextStyle title = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle price = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}

/// ---------------- SHADOWS ----------------
class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];
}


