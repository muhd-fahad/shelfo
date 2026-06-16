import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class SettingsHiveService {
  static const String _onboardedKey = 'isOnboarded';

  static Future<Box> _getBox() => HiveService.getBox(HiveService.settingsBox);

  static Future<bool> isOnboarded() async {
    final box = await _getBox();
    return box.get(_onboardedKey, defaultValue: false);
  }

  static Future<void> setOnboarded(bool value) async {
    final box = await _getBox();
    await box.put(_onboardedKey, value);
  }
}
