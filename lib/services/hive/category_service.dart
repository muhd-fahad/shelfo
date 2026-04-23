import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/category/category_model.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class CategoryHiveService {
  static Future<Box<Category>> _getBox() => HiveService.getBox<Category>(HiveService.categoriesBox);

  static Future<List<Category>> getCategories() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> saveCategories(List<Category> categories) async {
    final box = await _getBox();
    await box.addAll(categories);
  }

  static Future<void> addCategory(Category category) async {
    final box = await _getBox();
    await box.add(category);
  }

  static Future<void> updateCategory(dynamic key, Category category) async {
    final box = await _getBox();
    await box.put(key, category);
  }

  static Future<void> deleteCategory(Category category) async {
    await category.delete();
  }
}
