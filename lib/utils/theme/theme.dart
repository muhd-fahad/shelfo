import 'package:flutter/material.dart';
import 'app_constants/colors.dart';
import 'app_constants/radius.dart';
import 'app_constants/spacing.dart';

export 'app_constants/colors.dart';
export 'app_constants/spacing.dart';
export 'app_constants/radius.dart';
export 'app_constants/text_styles.dart';
export 'app_constants/shadows.dart';
export 'app_constants/assets.dart';

/// SFOAppTheme defines the global appearance of the Shelfo application.
/// It provides both Light and Dark modes following the system's Material 3 guidelines
/// while maintaining a custom design language using Superellipse borders.
class SFOAppTheme {
  SFOAppTheme._();

  static const String _fontFamily = 'Inter';

  static ThemeData light = _createTheme(Brightness.light);
  static ThemeData dark = _createTheme(Brightness.dark);


  static ThemeData _createTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    
    final Color primary = AppColors.primary;
    final Color surface = isDark ? AppColors.darkSurface : AppColors.surface;
    final Color onSurface = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final Color onSurfaceVariant = isDark ? AppColors.darkTextSecondary : AppColors.textSecondary;
    final Color background = isDark ? AppColors.darkBackground : AppColors.background;
    final Color outline = isDark ? AppColors.darkBorder : AppColors.border;
    final Color outlineVariant = isDark ? AppColors.darkBorder : AppColors.borderLight;

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: brightness,
      scaffoldBackgroundColor: surface,
      dividerColor: outlineVariant,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: AppColors.white,
        secondary: primary,
        onSecondary: AppColors.white,
        error: AppColors.error,
        onError: AppColors.white,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        surfaceContainer: surface,
        surfaceContainerHighest: outlineVariant,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: onSurface),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),

      cardTheme: CardThemeData(
        color: isDark ? AppColors.darkSurface : AppColors.white,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(color: outlineVariant),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.white,
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        border: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.md,
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: onSurfaceVariant,
          fontSize: 14,
          fontFamily: _fontFamily,
          fontWeight: FontWeight.w400,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: _fontFamily),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: _fontFamily),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          side: BorderSide(color: outline),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedSuperellipseBorder(borderRadius: AppRadius.md),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: _fontFamily),
        ),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: primary,
        unselectedLabelColor: onSurfaceVariant,
        indicatorColor: primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, fontFamily: _fontFamily),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, fontFamily: _fontFamily),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: surface,
        disabledColor: outlineVariant,
        selectedColor: primary.withOpacity(0.1),
        secondarySelectedColor: primary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: TextStyle(color: onSurface, fontSize: 12),
        secondaryLabelStyle: TextStyle(color: primary, fontSize: 12),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.sm),
        side: BorderSide(color: outlineVariant),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.white;
          return isDark ? AppColors.darkThumb : null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return outlineVariant;
        }),
      ),

      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: onSurface, letterSpacing: -0.25, fontFamily: _fontFamily),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: onSurface, fontFamily: _fontFamily),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: onSurface, fontFamily: _fontFamily),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: onSurface, fontFamily: _fontFamily),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: onSurface, fontFamily: _fontFamily),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: onSurface, fontFamily: _fontFamily),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: onSurface, fontFamily: _fontFamily),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface, fontFamily: _fontFamily),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: onSurface, fontFamily: _fontFamily),
        bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface, fontFamily: _fontFamily),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: onSurfaceVariant, fontFamily: _fontFamily),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: onSurfaceVariant, fontFamily: _fontFamily),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: onSurface, fontFamily: _fontFamily),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: _fontFamily),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: onSurfaceVariant, fontFamily: _fontFamily),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        surfaceTintColor: AppColors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
        selectedItemColor: primary,
        unselectedItemColor: onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, fontFamily: _fontFamily),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: _fontFamily),
      ),
    );
  }
}
