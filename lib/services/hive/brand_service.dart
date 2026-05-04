import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/brand/brand_model.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class BrandHiveService {
  static Future<Box<Brand>> _getBox() => HiveService.getBox<Brand>(HiveService.brandsBox);

  static Future<List<Brand>> getBrands() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> saveBrands(List<Brand> brands) async {
    final box = await _getBox();
    await box.addAll(brands);
  }

  static Future<void> addBrand(Brand brand) async {
    final box = await _getBox();
    await box.add(brand);
  }

  static Future<void> updateBrand(dynamic key, Brand brand) async {
    final box = await _getBox();
    await box.put(key, brand);
  }

  static Future<void> deleteBrand(Brand brand) async {
    await brand.delete();
  }
}
