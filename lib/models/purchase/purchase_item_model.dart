import 'package:hive_ce/hive.dart';

part 'purchase_item_model.g.dart';

@HiveType(typeId: 17)
class PurchaseItem {
  @HiveField(0)
  final String productId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final double costPrice;

  @HiveField(4)
  final double total;

  @HiveField(5)
  int receivedQuantity;

  PurchaseItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.costPrice,
    required this.total,
    this.receivedQuantity = 0,
  });
}
