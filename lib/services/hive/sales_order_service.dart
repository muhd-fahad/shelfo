import 'package:hive_ce/hive_ce.dart';
import '../../models/sale/sales_order_model.dart';
import 'hive_service.dart';

class SalesOrderHiveService {
  static Future<Box<SalesOrder>> _getBox() async {
    return HiveService.getBox<SalesOrder>(HiveService.salesOrdersBox);
  }

  static Future<List<SalesOrder>> getAllOrders() async {
    final box = await _getBox();
    return box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  static Future<void> saveOrder(SalesOrder order) async {
    final box = await _getBox();
    await box.add(order);
  }

  static Future<void> updateOrder(SalesOrder order) async {
    await order.save();
  }

  static Future<void> deleteOrder(SalesOrder order) async {
    await order.delete();
  }
}
