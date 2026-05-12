import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/services/hive/product_service.dart';
import '../models/product/product_model.dart';
import '../services/image_service.dart';

class ProductProvider extends ChangeNotifier {

  List<Product> _products = [];
  bool _isLoading = true;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // Controllers for add/edit product
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final skuController = TextEditingController();
  final initialStockController = TextEditingController();
  final minStockController = TextEditingController();
  final reorderPointController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final mrpController = TextEditingController();
  
  String? selectedCategory;
  String? selectedBrand;
  ProductType selectedType = ProductType.stocked;
  List<String> imagePaths = [];

  // Search and Filter
  final TextEditingController searchController = TextEditingController();
  final TextEditingController minPriceController = TextEditingController();
  final TextEditingController maxPriceController = TextEditingController();

  // Stock Adjustment Controllers
  final TextEditingController adjustmentQuantityController = TextEditingController(text: '1');
  final TextEditingController adjustmentCostController = TextEditingController();
  final TextEditingController adjustmentNotesController = TextEditingController();
  
  String _searchQuery = '';
  String? _filterCategory;
  String? _filterBrand;
  ProductType? _filterProductType;
  double? _minPrice;
  double? _maxPrice;
  String _stockStatus = 'All'; // All, In Stock, Low Stock, Out of Stock

  ProductProvider() {
    _loadProducts();
    searchController.addListener(() {
      setSearchQuery(searchController.text);
    });
  }

  Future<void> _loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await ProductHiveService.getProducts();
    _isLoading = false;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    return _products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                          (p.sku?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      
      final matchesCategory = _filterCategory == null || _filterCategory == 'All' || p.categoryName == _filterCategory;
      
      final matchesBrand = _filterBrand == null || _filterBrand == 'All' || p.brandName == _filterBrand;
      
      final matchesProductType = _filterProductType == null || p.productType == _filterProductType;
      
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

  String? get selectedFilterCategory => _filterCategory;
  String? get selectedFilterBrand => _filterBrand;
  ProductType? get selectedFilterProductType => _filterProductType;
  double? get minPrice => _minPrice;
  double? get maxPrice => _maxPrice;
  String get stockStatus => _stockStatus;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterCategory(String? category) {
    _filterCategory = category;
    notifyListeners();
  }

  void setFilterBrand(String? brand) {
    _filterBrand = brand;
    notifyListeners();
  }

  void setFilterProductType(ProductType? type) {
    _filterProductType = type;
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
    _filterCategory = null;
    _filterBrand = null;
    _filterProductType = null;
    _minPrice = null;
    _maxPrice = null;
    _stockStatus = 'All';
    minPriceController.clear();
    maxPriceController.clear();
    notifyListeners();
  }

  void initStockAdjustment(Product product) {
    adjustmentQuantityController.text = '1';
    adjustmentCostController.text = product.costPrice.toString();
    adjustmentNotesController.clear();
    notifyListeners();
  }

  int get totalProducts => _products.length;
  int get lowStockCount => _products.where((p) => p.stockQuantity <= p.minStock && p.stockQuantity > 0).length;
  int get outOfStockCount => _products.where((p) => p.stockQuantity <= 0).length;

  double get inventoryValue => _products.fold(0.0, (sum, p) => sum + (p.costPrice * p.stockQuantity));

  void initProduct(Product? product) {
    if (product != null) {
      nameController.text = product.name;
      descriptionController.text = product.description ?? '';
      skuController.text = product.sku ?? '';
      initialStockController.text = product.stockQuantity.toString();
      minStockController.text = product.minStock.toString();
      reorderPointController.text = product.reorderPoint.toString();
      purchasePriceController.text = product.costPrice.toString();
      mrpController.text = product.price.toString();
      selectedCategory = product.categoryName;
      selectedBrand = product.brandName;
      selectedType = product.productType;
      imagePaths = List.from(product.imagePaths ?? []);
    } else {
      nameController.clear();
      descriptionController.clear();
      skuController.clear();
      initialStockController.clear();
      minStockController.clear();
      reorderPointController.clear();
      purchasePriceController.clear();
      mrpController.clear();
      selectedCategory = null;
      selectedBrand = null;
      selectedType = ProductType.stocked;
      imagePaths = [];
    }
    notifyListeners();
  }

  void setCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  void setBrand(String? brand) {
    selectedBrand = brand;
    notifyListeners();
  }

  void setProductType(ProductType type) {
    selectedType = type;
    notifyListeners();
  }

  Future<void> pickAndAddImage(ImageSource source) async {
    final File? pickedFile = await ImageService.pickImage(source);
    if (pickedFile != null) {
      final String? savedPath = await ImageService.saveImageToLocalDirectory(pickedFile);
      if (savedPath != null) {
        imagePaths.add(savedPath);
        notifyListeners();
      }
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < imagePaths.length) {
      ImageService.deleteImage(imagePaths[index]);
      imagePaths.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> saveProduct(Product? existingProduct) async {
    final name = nameController.text.trim();
    final sku = skuController.text.trim();

    final isDuplicate = _products.any((p) =>
        (p.name.toLowerCase() == name.toLowerCase() || (sku.isNotEmpty && p.sku == sku)) &&
        (existingProduct == null || p.key != existingProduct.key));

    if (isDuplicate) {
      return false;
    }

    final product = Product(
      id: existingProduct?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      description: descriptionController.text.trim().isNotEmpty ? descriptionController.text.trim() : null,
      price: double.tryParse(mrpController.text) ?? 0.0,
      costPrice: double.tryParse(purchasePriceController.text) ?? 0.0,
      stockQuantity: int.tryParse(initialStockController.text) ?? 0,
      sku: sku.isNotEmpty ? sku : null,
      categoryName: selectedCategory,
      brandName: selectedBrand,
      createdAt: existingProduct?.createdAt ?? DateTime.now(),
      imagePaths: imagePaths,
      minStock: int.tryParse(minStockController.text) ?? 0,
      reorderPoint: int.tryParse(reorderPointController.text) ?? 0,
      productType: selectedType,
    );

    if (existingProduct == null) {
      await ProductHiveService.addProduct(product);
    } else {
      await ProductHiveService.updateProduct(existingProduct.key, product);
    }
    
    _products = await ProductHiveService.getProducts();
    notifyListeners();
    return true;
  }

  Future<void> adjustStock(Product product, int quantity, {bool isAddition = true, double? newCostPrice}) async {
    // We need to get the latest product from the list to avoid stale data
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index == -1) return;

    final latestProduct = _products[index];
    final newQuantity = isAddition ? latestProduct.stockQuantity + quantity : latestProduct.stockQuantity - quantity;
    
    final updatedProduct = latestProduct.copyWith(
      stockQuantity: newQuantity,
      costPrice: newCostPrice ?? latestProduct.costPrice,
    );
    await ProductHiveService.updateProduct(latestProduct.key, updatedProduct);
    _products = await ProductHiveService.getProducts();
    notifyListeners();
  }

  Future<void> deleteProduct(Product product) async {
    await ProductHiveService.deleteProduct(product);
    _products.remove(product);
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    skuController.dispose();
    initialStockController.dispose();
    minStockController.dispose();
    reorderPointController.dispose();
    purchasePriceController.dispose();
    mrpController.dispose();
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    adjustmentQuantityController.dispose();
    adjustmentCostController.dispose();
    adjustmentNotesController.dispose();
    super.dispose();
  }
}
