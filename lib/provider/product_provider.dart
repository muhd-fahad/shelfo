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
  String _searchQuery = '';
  String? _filterCategory;

  ProductProvider() {
    _loadProducts();
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
      return matchesSearch && matchesCategory;
    }).toList();
  }

  String? get selectedFilterCategory => _filterCategory;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterCategory(String? category) {
    _filterCategory = category;
    notifyListeners();
  }

  int get totalProducts => _products.length;
  int get lowStockCount => _products.where((p) => p.stockQuantity <= p.minStock && p.stockQuantity > 0).length;
  int get outOfStockCount => _products.where((p) => p.stockQuantity <= 0).length;

  void initProduct(Product? product) {
    if (product != null) {
      nameController.text = product.name;
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
    final newQuantity = isAddition ? product.stockQuantity + quantity : product.stockQuantity - quantity;
    final updatedProduct = product.copyWith(
      stockQuantity: newQuantity,
      costPrice: newCostPrice ?? product.costPrice,
    );
    await ProductHiveService.updateProduct(product.key, updatedProduct);
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
    skuController.dispose();
    initialStockController.dispose();
    minStockController.dispose();
    reorderPointController.dispose();
    purchasePriceController.dispose();
    mrpController.dispose();
    super.dispose();
  }
}
