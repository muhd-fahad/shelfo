import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/brand/brand_model.dart';

class BrandProvider extends ChangeNotifier {
  static const String _boxName = 'brandsBox';

  final TextEditingController nameController = TextEditingController();

  List<Brand> _brands = [];
  List<Brand> get brands => _brands;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  BrandProvider() {
    _loadBrands();
  }

  Future<void> _loadBrands() async {
    _isLoading = true;
    notifyListeners();

    final box = await Hive.openBox<Brand>(_boxName);
    
    if (box.isEmpty) {
      final defaultBrands = [
        // Tech & Smartphones
        Brand(name: 'Apple'),
        Brand(name: 'Samsung'),
        Brand(name: 'Google'),
        Brand(name: 'Microsoft'),
        Brand(name: 'Xiaomi'),
        Brand(name: 'Oppo'),
        Brand(name: 'Vivo'),
        Brand(name: 'OnePlus'),
        Brand(name: 'Realme'),
        Brand(name: 'Nothing'),

        // Laptops & Computing
        Brand(name: 'Dell'),
        Brand(name: 'HP'),
        Brand(name: 'Lenovo'),
        Brand(name: 'Asus'),
        Brand(name: 'Acer'),
        Brand(name: 'MSI'),
        Brand(name: 'Razer'),

        // Consumer Electronics & Cameras
        Brand(name: 'Sony'),
        Brand(name: 'LG'),
        Brand(name: 'Panasonic'),
        Brand(name: 'Canon'),
        Brand(name: 'Nikon'),
        Brand(name: 'Fujifilm'),

        // Audio & Accessories
        Brand(name: 'Bose'),
        Brand(name: 'Sennheiser'),
        Brand(name: 'JBL'),
        Brand(name: 'Marshall'),
        Brand(name: 'Logitech'),

        // Components & Others
        Brand(name: 'Intel'),
        Brand(name: 'AMD'),
        Brand(name: 'Nvidia'),
        Brand(name: 'TP-Link'),
      ];
      await box.addAll(defaultBrands);
    }

    _brands = box.values.toList();
    _isLoading = false;
    notifyListeners();
  }

  void initBrand(Brand? brand) {
    if (brand != null) {
      nameController.text = brand.name;
    } else {
      nameController.clear();
    }
    notifyListeners();
  }

  Future<bool> saveBrand(Brand? existingBrand) async {
    final box = await Hive.openBox<Brand>(_boxName);
    final newName = nameController.text.trim();

    // Check for duplication
    final isDuplicate = box.values.any((brand) =>
        brand.name.toLowerCase() == newName.toLowerCase() &&
        (existingBrand == null || brand.key != existingBrand.key));

    if (isDuplicate) {
      return false;
    }

    if (existingBrand == null) {
      final brand = Brand(
        name: newName,
      );
      await box.add(brand);
    } else {
      final updated = Brand(
        name: newName,
      );
      // Use the Hive key to update the existing entry
      await box.put(existingBrand.key, updated);
    }

    _brands = box.values.toList();
    notifyListeners();
    return true;
  }

  Future<void> deleteBrand(Brand brand) async {
    await brand.delete();
    _brands.remove(brand);
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
