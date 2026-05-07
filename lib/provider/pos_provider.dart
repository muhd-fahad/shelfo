import 'package:flutter/material.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/provider/product_provider.dart';

class PosProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedBrand;
  ProductType? _selectedProductType;
  double? _minPrice;
  double? _maxPrice;
  String _stockStatus = 'All'; // All, In Stock, Low Stock, Out of Stock

  PosProvider() {
    searchController.addListener(() {
      _searchQuery = searchController.text;
      notifyListeners();
    });
  }

  String? get selectedCategory => _selectedCategory;
  String? get selectedBrand => _selectedBrand;
  ProductType? get selectedProductType => _selectedProductType;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String get stockStatus => _stockStatus;

  void setCategory(String? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setBrand(String? brand) {
    _selectedBrand = brand;
    notifyListeners();
  }

  void setProductType(ProductType? type) {
    _selectedProductType = type;
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void setStockStatus(String status) {
    _stockStatus = status;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategory = null;
    _selectedBrand = null;
    _selectedProductType = null;
    _minPrice = null;
    _maxPrice = null;
    _stockStatus = 'All';
    minPriceController.clear();
    maxPriceController.clear();
    notifyListeners();
  }

  List<Product> getFilteredProducts(ProductProvider productProvider) {
    return productProvider.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                          (p.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      final matchesCategory = _selectedCategory == null || _selectedCategory == 'All' || p.categoryName == _selectedCategory;
      
      final matchesBrand = _selectedBrand == null || _selectedBrand == 'All' || p.brandName == _selectedBrand;
      
      final matchesProductType = _selectedProductType == null || p.productType == _selectedProductType;
      
      final matchesPrice = (_minPrice == null || p.price >= _minPrice!) && 
                          (_maxPrice == null || p.price <= _maxPrice!);

      bool matchesStock = true;
      if (_stockStatus == 'In Stock') {
        matchesStock = p.stockQuantity > 0;
      } else if (_stockStatus == 'Low Stock') {
        matchesStock = p.stockQuantity <= p.minStock && p.stockQuantity > 0;
      } else if (_stockStatus == 'Out of Stock') {
        matchesStock = p.stockQuantity <= 0;
      }

      return matchesSearch && matchesCategory && matchesBrand && matchesProductType && matchesPrice && matchesStock;
    }).toList();
  }

  @override
  void dispose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    super.dispose();
  }
}
