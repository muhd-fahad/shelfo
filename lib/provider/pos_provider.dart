import 'package:flutter/material.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/provider/product_provider.dart';

class PosProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  String _searchQuery = '';
  final List<String> _selectedCategories = [];
  final List<String> _selectedBrands = [];
  final List<ProductType> _selectedProductTypes = [];
  double? _minPrice;
  double? _maxPrice;
  final List<String> _stockStatuses = []; // All, In Stock, Low Stock, Out of Stock

  PosProvider() {
    searchController.addListener(() {
      _searchQuery = searchController.text;
      notifyListeners();
    });
  }

  List<String> get selectedCategories => _selectedCategories;
  List<String> get selectedBrands => _selectedBrands;
  List<ProductType> get selectedProductTypes => _selectedProductTypes;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  List<String> get stockStatuses => _stockStatuses;

  void toggleCategory(String? category) {
    if (category == null) {
      _selectedCategories.clear();
    } else {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    }
    notifyListeners();
  }

  void toggleBrand(String? brand) {
    if (brand == null) {
      _selectedBrands.clear();
    } else {
      if (_selectedBrands.contains(brand)) {
        _selectedBrands.remove(brand);
      } else {
        _selectedBrands.add(brand);
      }
    }
    notifyListeners();
  }

  void toggleProductType(ProductType? type) {
    if (type == null) {
      _selectedProductTypes.clear();
    } else {
      if (_selectedProductTypes.contains(type)) {
        _selectedProductTypes.remove(type);
      } else {
        _selectedProductTypes.add(type);
      }
    }
    notifyListeners();
  }

  void setPriceRange(double? min, double? max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void toggleStockStatus(String status) {
    if (status == 'All') {
      _stockStatuses.clear();
    } else {
      if (_stockStatuses.contains(status)) {
        _stockStatuses.remove(status);
      } else {
        _stockStatuses.add(status);
      }
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategories.clear();
    _selectedBrands.clear();
    _selectedProductTypes.clear();
    _minPrice = null;
    _maxPrice = null;
    _stockStatuses.clear();
    minPriceController.clear();
    maxPriceController.clear();
    notifyListeners();
  }

  List<Product> getFilteredProducts(ProductProvider productProvider) {
    return productProvider.products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                          (p.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(p.categoryName);
      
      final matchesBrand = _selectedBrands.isEmpty || _selectedBrands.contains(p.brandName);
      
      final matchesProductType = _selectedProductTypes.isEmpty || _selectedProductTypes.contains(p.productType);
      
      final matchesPrice = (_minPrice == null || p.price >= _minPrice!) && 
                          (_maxPrice == null || p.price <= _maxPrice!);

      bool matchesStock = _stockStatuses.isEmpty || _stockStatuses.contains('All');
      if (!matchesStock) {
        matchesStock = false;
        if (_stockStatuses.contains('In Stock') && p.stockQuantity > 0) {
          matchesStock = true;
        }
        if (_stockStatuses.contains('Low Stock') && p.stockQuantity <= p.minStock && p.stockQuantity > 0) {
          matchesStock = true;
        }
        if (_stockStatuses.contains('Out of Stock') && p.stockQuantity <= 0) {
          matchesStock = true;
        }
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
