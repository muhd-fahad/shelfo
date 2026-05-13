import 'package:hive_ce/hive.dart';

part 'sale_item_model.g.dart';

@HiveType(typeId: 10)
class SaleItem {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double price;

  @HiveField(4)
  final double total;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.total,
  });
}
