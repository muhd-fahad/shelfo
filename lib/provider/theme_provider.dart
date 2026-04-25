import 'package:flutter/material.dart';
import '../services/hive/hive_service.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeModeKey = 'themeMode';
  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> _loadThemeMode() async {
    final box = await HiveService.getBox(HiveService.settingsBox);
    final String? modeString = box.get(_themeModeKey);
    
    if (modeString != null) {
      _themeMode = ThemeMode.values.firstWhere(
        (e) => e.toString() == modeString,
        orElse: () => ThemeMode.system,
      );
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    
    _themeMode = mode;
    notifyListeners();
    
    final box = await HiveService.getBox(HiveService.settingsBox);
    await box.put(_themeModeKey, mode.toString());
  }

  Future<void> toggleTheme(bool isDark) async {
    await setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
