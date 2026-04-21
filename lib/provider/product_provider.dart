import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product/product_model.dart';
import '../utils/image_service.dart';

class ProductProvider with ChangeNotifier {
  late Box<Product> _productBox;
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
    _init();
  }

  Future<void> _init() async {
    _productBox = await Hive.openBox<Product>('products');
    _products = _productBox.values.toList();
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
      imagePaths = product.imagePaths ?? [];
    } else {
      clearControllers();
    }
  }

  void clearControllers() {
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
      // We might want to delete the file from storage too
      ImageService.deleteImage(imagePaths[index]);
      imagePaths.removeAt(index);
      notifyListeners();
    }
  }

  Future<void> saveProduct(Product? existingProduct) async {
    final product = Product(
      id: existingProduct?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      price: double.tryParse(mrpController.text) ?? 0.0,
      costPrice: double.tryParse(purchasePriceController.text) ?? 0.0,
      stockQuantity: int.tryParse(initialStockController.text) ?? 0,
      sku: skuController.text,
      categoryName: selectedCategory,
      brandName: selectedBrand,
      createdAt: existingProduct?.createdAt ?? DateTime.now(),
      imagePaths: imagePaths,
      minStock: int.tryParse(minStockController.text) ?? 0,
      reorderPoint: int.tryParse(reorderPointController.text) ?? 0,
      productType: selectedType,
    );

    if (existingProduct != null) {
      final index = _products.indexWhere((p) => p.id == existingProduct.id);
      if (index != -1) {
        await _productBox.putAt(index, product);
        _products[index] = product;
      }
    } else {
      await _productBox.add(product);
      _products.add(product);
    }
    notifyListeners();
  }

  Future<void> adjustStock(Product product, int quantity, {bool isAddition = true, double? newCostPrice}) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      final newQuantity = isAddition ? product.stockQuantity + quantity : product.stockQuantity - quantity;
      final updatedProduct = product.copyWith(
        stockQuantity: newQuantity,
        costPrice: newCostPrice ?? product.costPrice,
      );
      await _productBox.putAt(index, updatedProduct);
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      await _productBox.deleteAt(index);
      _products.removeAt(index);
      notifyListeners();
    }
  }
}
