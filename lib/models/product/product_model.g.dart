// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final typeId = 6;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      price: (fields[3] as num).toDouble(),
      costPrice: (fields[4] as num).toDouble(),
      stockQuantity: (fields[5] as num).toInt(),
      sku: fields[6] as String?,
      barcode: fields[7] as String?,
      categoryName: fields[8] as String?,
      unit: fields[9] as String?,
      createdAt: fields[10] as DateTime,
      imagePaths: (fields[11] as List?)?.cast<String>(),
      minStock: fields[12] == null ? 0 : (fields[12] as num).toInt(),
      reorderPoint: fields[13] == null ? 0 : (fields[13] as num).toInt(),
      productType: fields[14] == null
          ? ProductType.stocked
          : fields[14] as ProductType,
      brandName: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.costPrice)
      ..writeByte(5)
      ..write(obj.stockQuantity)
      ..writeByte(6)
      ..write(obj.sku)
      ..writeByte(7)
      ..write(obj.barcode)
      ..writeByte(8)
      ..write(obj.categoryName)
      ..writeByte(9)
      ..write(obj.unit)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.imagePaths)
      ..writeByte(12)
      ..write(obj.minStock)
      ..writeByte(13)
      ..write(obj.reorderPoint)
      ..writeByte(14)
      ..write(obj.productType)
      ..writeByte(15)
      ..write(obj.brandName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ProductTypeAdapter extends TypeAdapter<ProductType> {
  @override
  final typeId = 7;

  @override
  ProductType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ProductType.stocked;
      case 1:
        return ProductType.serialized;
      case 2:
        return ProductType.nonStocked;
      case 3:
        return ProductType.service;
      default:
        return ProductType.stocked;
    }
  }

  @override
  void write(BinaryWriter writer, ProductType obj) {
    switch (obj) {
      case ProductType.stocked:
        writer.writeByte(0);
      case ProductType.serialized:
        writer.writeByte(1);
      case ProductType.nonStocked:
        writer.writeByte(2);
      case ProductType.service:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
