import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class ProductHiveService {
  static Future<Box<Product>> _getBox() => HiveService.getBox<Product>(HiveService.productsBox);

  static Future<List<Product>> getProducts() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> addProduct(Product product) async {
    final box = await _getBox();
    await box.add(product);
  }

  static Future<void> updateProduct(dynamic key, Product product) async {
    final box = await _getBox();
    await box.put(key, product);
  }

  static Future<void> deleteProduct(Product product) async {
    await product.delete();
  }
}
