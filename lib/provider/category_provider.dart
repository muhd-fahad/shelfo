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
        Category(id: '1', name: 'Smartphones', iconCode: Icons.smartphone.codePoint),
        Category(id: '2', name: 'Laptops', iconCode: Icons.laptop.codePoint),
        Category(id: '3', name: 'Accessories', iconCode: Icons.headphones.codePoint),
        Category(id: '4', name: 'Tablets', iconCode: Icons.tablet.codePoint),
        Category(id: '5', name: 'Smart Watches', iconCode: Icons.watch.codePoint),
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

  Future<void> saveCategory(Category? existingCategory) async {
    final box = await Hive.openBox<Category>(_boxName);
    
    if (existingCategory == null) {
      final category = Category(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: nameController.text,
        description: descController.text,
        iconCode: _selectedIconCode,
      );
      await box.add(category);
    } else {
      final updated = existingCategory.copyWith(
        name: nameController.text,
        description: descController.text,
        iconCode: _selectedIconCode,
      );
      await updated.save();
    }
    
    _categories = box.values.toList();
    notifyListeners();
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
