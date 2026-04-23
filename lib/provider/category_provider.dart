import 'package:flutter/material.dart';
import 'package:shelfo/models/category/category_model.dart';
import 'package:shelfo/services/hive/category_service.dart';

class CategoryProvider extends ChangeNotifier {
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

    _categories = await CategoryHiveService.getCategories();
    
    if (_categories.isEmpty) {
      final defaultCategories = [
        Category(name: 'Smartphones', iconCode: Icons.smartphone_rounded.codePoint),
        Category(name: 'Laptops', iconCode: Icons.laptop_rounded.codePoint),
        Category(name: 'Accessories', iconCode: Icons.headphones_rounded.codePoint),
        Category(name: 'Tablets', iconCode: Icons.tablet_rounded.codePoint),
        Category(name: 'Smart Watches', iconCode: Icons.watch_rounded.codePoint),
      ];
      await CategoryHiveService.saveCategories(defaultCategories);
      _categories = await CategoryHiveService.getCategories();
    }

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
    final newName = nameController.text.trim();

    final isDuplicate = _categories.any((category) =>
        category.name.toLowerCase() == newName.toLowerCase() &&
        (existingCategory == null || category.key != existingCategory.key));

    if (isDuplicate) {
      return false;
    }

    final category = Category(
      name: newName,
      description: descController.text.trim(),
      iconCode: _selectedIconCode,
    );

    if (existingCategory == null) {
      await CategoryHiveService.addCategory(category);
    } else {
      await CategoryHiveService.updateCategory(existingCategory.key, category);
    }

    _categories = await CategoryHiveService.getCategories();
    notifyListeners();
    return true;
  }

  Future<void> deleteCategory(Category category) async {
    await CategoryHiveService.deleteCategory(category);
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
