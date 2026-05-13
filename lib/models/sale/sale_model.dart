import 'package:hive_ce/hive.dart';
import 'sale_item_model.dart';

part 'sale_model.g.dart';

@HiveType(typeId: 9)
class Sale extends HiveObject {
  @HiveField(0)
  final String id; // Invoice ID

  @HiveField(1)
  final DateTime dateTime;

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
  final String paymentMethod;

  @HiveField(8)
  String status; // 'Paid', 'Refunded'

  Sale({
    required this.id,
    required this.dateTime,
    required this.customerName,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required this.paymentMethod,
    this.status = 'Paid',
  });
}
