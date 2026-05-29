import 'package:hive_ce/hive.dart';
import 'sale_item_model.dart';

enum SalesOrderStatus {
  all,
  draft,
  pending,
  fulfilled,
  inTransit,
  cancelled,
}

class SalesOrder extends HiveObject {
  final String id;
  final DateTime date;
  final String customerName;
  final List<SaleItem> items;
  final double subtotal;
  final double taxAmount;
  final double total;
  SalesOrderStatus status;
  final String? notes;
  final bool isPaid;

  SalesOrder({
    required this.id,
    required this.date,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required this.status,
    this.notes,
    this.isPaid = false,
  });
}
