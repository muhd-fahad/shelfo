import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/category/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  static const String _boxName = 'categoriesBox';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  
  int? _selectedIconCode = Icons.category_rounded.codePoint;
  int? get selectedIconCode => _selectedIconCode;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  CategoryProvider() {
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    _isLoading = true;
    notifyListeners();

    final box = await Hive.openBox<Category>(_boxName);
    
    if (box.isEmpty) {
      final defaultCategories = [
        Category(name: 'Smartphones', iconCode: Icons.smartphone_rounded.codePoint),
        Category(name: 'Laptops', iconCode: Icons.laptop_rounded.codePoint),
        Category(name: 'Accessories', iconCode: Icons.headphones_rounded.codePoint),
        Category(name: 'Tablets', iconCode: Icons.tablet_rounded.codePoint),
        Category(name: 'Smart Watches', iconCode: Icons.watch_rounded.codePoint),
      ];
      await box.addAll(defaultCategories);
    }

    _categories = box.values.toList();
    _isLoading = false;
    notifyListeners();
  }

  void initCategory(Category? category) {
    if (category != null) {
      nameController.text = category.name;
      descController.text = category.description ?? "";
      _selectedIconCode = category.iconCode;
    } else {
      nameController.clear();
      descController.clear();
      _selectedIconCode = Icons.category_rounded.codePoint;
    }
    notifyListeners();
  }

  void setIconCode(int? code) {
    _selectedIconCode = code;
    notifyListeners();
  }

  Future<bool> saveCategory(Category? existingCategory) async {
    final box = await Hive.openBox<Category>(_boxName);
    final newName = nameController.text.trim();

    // Check for duplication
    final isDuplicate = box.values.any((category) =>
        category.name.toLowerCase() == newName.toLowerCase() &&
        (existingCategory == null || category.key != existingCategory.key));

    if (isDuplicate) {
      return false;
    }

    if (existingCategory == null) {
      final category = Category(
        name: newName,
        description: descController.text.trim(),
        iconCode: _selectedIconCode,
      );
      await box.add(category);
    } else {
      final updated = Category(
        name: newName,
        description: descController.text.trim(),
        iconCode: _selectedIconCode,
      );
      // Use the Hive key to update the existing entry
      await box.put(existingCategory.key, updated);
    }

    _categories = box.values.toList();
    notifyListeners();
    return true;
  }

  Future<void> deleteCategory(Category category) async {
    await category.delete();
    _categories.remove(category);
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }
}
