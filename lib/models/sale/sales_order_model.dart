import 'package:hive_ce/hive.dart';
import 'sale_item_model.dart';

part 'sales_order_model.g.dart';

@HiveType(typeId: 21)
enum SalesOrderStatus {
  @HiveField(0)
  all,
  @HiveField(1)
  draft,
  @HiveField(2)
  pending,
  @HiveField(3)
  fulfilled,
  @HiveField(4)
  inTransit,
  @HiveField(5)
  cancelled,
}

@HiveType(typeId: 20)
class SalesOrder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String customerName;

  @HiveField(3)
  final List<SaleItem> items;

  @HiveField(4)
  final double subtotal;

  @HiveField(5)
  final double taxAmount;

  @HiveField(6)
  final double total;

  @HiveField(7)
  SalesOrderStatus status;

  @HiveField(8)
  final String? notes;

  @HiveField(9)
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
