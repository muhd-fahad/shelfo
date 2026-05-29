import 'package:hive_ce/hive.dart';
import 'purchase_item_model.dart';

part 'purchase_order_model.g.dart';

@HiveType(typeId: 18)
enum PurchaseOrderStatus {
  @HiveField(0)
  draft,
  @HiveField(1)
  ordered,
  @HiveField(2)
  partial,
  @HiveField(3)
  received,
  @HiveField(4)
  cancelled,
}

@HiveType(typeId: 19)
class PurchaseOrder extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final DateTime? expectedDate;

  @HiveField(3)
  final String vendorId;

  @HiveField(4)
  final String vendorName;

  @HiveField(5)
  final List<PurchaseItem> items;

  @HiveField(6)
  final double subtotal;

  @HiveField(7)
  final double taxAmount;

  @HiveField(8)
  final double total;

  @HiveField(9)
  PurchaseOrderStatus status;

  @HiveField(10)
  final String? notes;

  PurchaseOrder({
    required this.id,
    required this.date,
    this.expectedDate,
    required this.vendorId,
    required this.vendorName,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    this.status = PurchaseOrderStatus.draft,
    this.notes,
  });

  PurchaseOrder copyWith({
    String? id,
    DateTime? date,
    DateTime? expectedDate,
    String? vendorId,
    String? vendorName,
    List<PurchaseItem>? items,
    double? subtotal,
    double? taxAmount,
    double? total,
    PurchaseOrderStatus? status,
    String? notes,
  }) {
    return PurchaseOrder(
      id: id ?? this.id,
      date: date ?? this.date,
      expectedDate: expectedDate ?? this.expectedDate,
      vendorId: vendorId ?? this.vendorId,
      vendorName: vendorName ?? this.vendorName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}
