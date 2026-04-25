import 'package:hive_ce_flutter/hive_ce_flutter.dart';

class HiveService {
  // Box Names
  static const String businessBox = 'businessBox';
  static const String taxBox = 'taxBox';
  static const String invoiceBox = 'invoiceBox';
  static const String categoriesBox = 'categoriesBox';
  static const String brandsBox = 'brandsBox';
  static const String productsBox = 'productsBox';
  static const String settingsBox = 'settingsBox';

  /// Opens a box with the given name
  static Future<Box<T>> getBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Gets a value from a box
  static Future<T?> get<T>(String boxName, dynamic key) async {
    final box = await getBox<T>(boxName);
    return box.get(key);
  }

  /// Puts a value into a box
  static Future<void> put<T>(String boxName, dynamic key, T value) async {
    final box = await getBox<T>(boxName);
    await box.put(key, value);
  }

  /// Deletes a value from a box
  static Future<void> delete<T>(String boxName, dynamic key) async {
    final box = await getBox<T>(boxName);
    await box.delete(key);
  }

  /// Clears all entries from a box
  static Future<void> clearBox(String boxName) async {
    final box = await getBox(boxName);
    await box.clear();
  }

  /// Deletes a box from disk
  static Future<void> deleteBoxFromDisk(String boxName) async {
    await Hive.deleteBoxFromDisk(boxName);
  }
}
