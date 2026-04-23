import 'package:flutter/material.dart';
import 'package:shelfo/models/brand/brand_model.dart';
import 'package:shelfo/services/hive/brand_service.dart';

class BrandProvider extends ChangeNotifier {
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

    _brands = await BrandHiveService.getBrands();
    
    if (_brands.isEmpty) {
      final defaultBrands = [
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
        Brand(name: 'Dell'),
        Brand(name: 'HP'),
        Brand(name: 'Lenovo'),
        Brand(name: 'Asus'),
        Brand(name: 'Acer'),
        Brand(name: 'MSI'),
        Brand(name: 'Razer'),
        Brand(name: 'Sony'),
        Brand(name: 'LG'),
        Brand(name: 'Panasonic'),
        Brand(name: 'Canon'),
        Brand(name: 'Nikon'),
        Brand(name: 'Fujifilm'),
        Brand(name: 'Bose'),
        Brand(name: 'Sennheiser'),
        Brand(name: 'JBL'),
        Brand(name: 'Marshall'),
        Brand(name: 'Logitech'),
        Brand(name: 'Intel'),
        Brand(name: 'AMD'),
        Brand(name: 'Nvidia'),
        Brand(name: 'TP-Link'),
      ];
      await BrandHiveService.saveBrands(defaultBrands);
      _brands = await BrandHiveService.getBrands();
    }

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
    final newName = nameController.text.trim();

    final isDuplicate = _brands.any((brand) =>
        brand.name.toLowerCase() == newName.toLowerCase() &&
        (existingBrand == null || brand.key != existingBrand.key));

    if (isDuplicate) {
      return false;
    }

    final brand = Brand(name: newName);

    if (existingBrand == null) {
      await BrandHiveService.addBrand(brand);
    } else {
      await BrandHiveService.updateBrand(existingBrand.key, brand);
    }

    _brands = await BrandHiveService.getBrands();
    notifyListeners();
    return true;
  }

  Future<void> deleteBrand(Brand brand) async {
    await BrandHiveService.deleteBrand(brand);
    _brands.remove(brand);
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
