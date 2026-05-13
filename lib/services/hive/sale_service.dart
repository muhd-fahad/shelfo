import 'package:hive_ce/hive_ce.dart';
import '../../models/sale/sale_model.dart';
import 'hive_service.dart';

class SaleHiveService {
  static Future<Box<Sale>> _getBox() async {
    return HiveService.getBox<Sale>(HiveService.salesBox);
  }

  static Future<List<Sale>> getAllSales() async {
    final box = await _getBox();
    return box.values.toList()..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  static Future<void> saveSale(Sale sale) async {
    final box = await _getBox();
    await box.add(sale);
  }

  static Future<void> updateSale(Sale sale) async {
    await sale.save();
  }

  static Future<void> deleteSale(Sale sale) async {
    await sale.delete();
  }
}
