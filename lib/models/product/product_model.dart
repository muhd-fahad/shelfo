import 'package:hive_ce/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 7)
enum ProductType {
  @HiveField(0)
  stocked,
  @HiveField(1)
  serialized,
  @HiveField(2)
  nonStocked,
  @HiveField(3)
  service,
}

extension ProductTypeExtension on ProductType {
  String get label {
    switch (this) {
      case ProductType.stocked:
        return "Stocked";
      case ProductType.serialized:
        return "Serialized";
      case ProductType.nonStocked:
        return "Non-stocked";
      case ProductType.service:
        return "Service";
    }
  }
}

@HiveType(typeId: 6)
class Product extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double costPrice;

  @HiveField(5)
  final int stockQuantity;

  @HiveField(6)
  final String? sku;

  @HiveField(7)
  final String? barcode;

  @HiveField(8)
  final String? categoryName;

  @HiveField(15)
  final String? brandName;

  @HiveField(9)
  final String? unit;

  @HiveField(10)
  final DateTime createdAt;

  @HiveField(11)
  final List<String>? imagePaths;

  @HiveField(12)
  final int minStock;

  @HiveField(13)
  final int reorderPoint;

  @HiveField(14)
  final ProductType productType;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.costPrice,
    required this.stockQuantity,
    this.sku,
    this.barcode,
    this.categoryName,
    this.unit,
    required this.createdAt,
    this.imagePaths,
    this.minStock = 0,
    this.reorderPoint = 0,
    this.productType = ProductType.stocked, this.brandName,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? costPrice,
    int? stockQuantity,
    String? sku,
    String? barcode,
    String? categoryName,
    String? brandName,
    String? unit,
    DateTime? createdAt,
    List<String>? imagePaths,
    int? minStock,
    int? reorderPoint,
    ProductType? productType,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryName: categoryName ?? this.categoryName,
      brandName: brandName ?? this.brandName,
      unit: unit ?? this.unit,
      createdAt: createdAt ?? this.createdAt,
      imagePaths: imagePaths ?? this.imagePaths,
      minStock: minStock ?? this.minStock,
      reorderPoint: reorderPoint ?? this.reorderPoint,
      productType: productType ?? this.productType,
    );
  }
}
