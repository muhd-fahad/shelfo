import 'package:flutter/material.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

/// SFOAppTheme defines the global appearance of the Shelfo application.
/// It provides both Light and Dark modes following the system's Material 3 guidelines
/// while maintaining a custom design language using Superellipse borders.
class SFOAppTheme {
  SFOAppTheme._();

  /// ---------------- LIGHT THEME ----------------

  static ThemeData light = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.surface,
    dividerColor: AppColors.borderLight,

    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primary,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.border,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedSuperellipseBorder(
        borderRadius: AppRadius.lg,
        side: const BorderSide(color: AppColors.borderLight),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: Colors.red),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.textSecondary,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Inter'),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, fontFamily: 'Inter'),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      disabledColor: AppColors.borderLight,
      selectedColor: AppColors.primary.withOpacity(0.1),
      secondarySelectedColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(color: AppColors.textPrimary, fontSize: 12),
      secondaryLabelStyle: const TextStyle(color: AppColors.primary, fontSize: 12),
      shape: RoundedSuperellipseBorder(borderRadius: AppRadius.sm),
      side: const BorderSide(color: AppColors.borderLight),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return null;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.borderLight;
      }),
    ),

    textTheme: const TextTheme(
      // Display Styles
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: AppColors.textPrimary, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      
      // Headline Styles
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      
      // Title Styles
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary, ),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary, ),
      
      // Body Styles
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary, ),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondary, ),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textSecondary, ),
      
      // Label Styles
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary, ),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondary, ),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textMuted, ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
  );

  /// ---------------- DARK THEME ----------------

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    dividerColor: AppColors.darkBorder,

    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primary,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkTextPrimary,
      outline: AppColors.darkBorder,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkTextPrimary,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary),
      titleTextStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.darkTextPrimary,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.darkSurface,
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedSuperellipseBorder(
        borderRadius: AppRadius.lg,
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      contentPadding: const EdgeInsets.all(AppSpacing.md),
      border: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.md,
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      hintStyle: const TextStyle(
        color: AppColors.darkTextSecondary,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        side: const BorderSide(color: AppColors.darkBorder),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
      ),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.darkTextSecondary,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, fontFamily: 'Inter'),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, fontFamily: 'Inter'),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.darkSurface,
      disabledColor: AppColors.darkBorder,
      selectedColor: AppColors.primary.withOpacity(0.2),
      secondarySelectedColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(color: AppColors.darkTextPrimary, fontSize: 12),
      secondaryLabelStyle: const TextStyle(color: AppColors.primary, fontSize: 12),
      shape: RoundedSuperellipseBorder(borderRadius: AppRadius.sm),
      side: const BorderSide(color: AppColors.darkBorder),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return Colors.white;
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.primary;
        return AppColors.darkBorder;
      }),
    ),

    textTheme: const TextTheme(
      // Display Styles
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.darkTextPrimary, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.darkTextPrimary),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.darkTextPrimary),
      
      // Headline Styles
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      
      // Title Styles
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary,),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary, ),
      
      // Body Styles
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.darkTextPrimary, ),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.darkTextSecondary,),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.darkTextSecondary, ),
      
      // Label Styles
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.darkTextPrimary, ),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.darkTextSecondary, ),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.darkTextSecondary, ),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
  );
}