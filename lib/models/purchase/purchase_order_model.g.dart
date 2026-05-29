// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PurchaseOrderAdapter extends TypeAdapter<PurchaseOrder> {
  @override
  final typeId = 19;

  @override
  PurchaseOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurchaseOrder(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      expectedDate: fields[2] as DateTime?,
      vendorId: fields[3] as String,
      vendorName: fields[4] as String,
      items: (fields[5] as List).cast<PurchaseItem>(),
      subtotal: (fields[6] as num).toDouble(),
      taxAmount: (fields[7] as num).toDouble(),
      total: (fields[8] as num).toDouble(),
      status: fields[9] == null
          ? PurchaseOrderStatus.draft
          : fields[9] as PurchaseOrderStatus,
      notes: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseOrder obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.expectedDate)
      ..writeByte(3)
      ..write(obj.vendorId)
      ..writeByte(4)
      ..write(obj.vendorName)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.subtotal)
      ..writeByte(7)
      ..write(obj.taxAmount)
      ..writeByte(8)
      ..write(obj.total)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PurchaseOrderStatusAdapter extends TypeAdapter<PurchaseOrderStatus> {
  @override
  final typeId = 18;

  @override
  PurchaseOrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PurchaseOrderStatus.draft;
      case 1:
        return PurchaseOrderStatus.ordered;
      case 2:
        return PurchaseOrderStatus.partial;
      case 3:
        return PurchaseOrderStatus.received;
      case 4:
        return PurchaseOrderStatus.cancelled;
      default:
        return PurchaseOrderStatus.draft;
    }
  }

  @override
  void write(BinaryWriter writer, PurchaseOrderStatus obj) {
    switch (obj) {
      case PurchaseOrderStatus.draft:
        writer.writeByte(0);
      case PurchaseOrderStatus.ordered:
        writer.writeByte(1);
      case PurchaseOrderStatus.partial:
        writer.writeByte(2);
      case PurchaseOrderStatus.received:
        writer.writeByte(3);
      case PurchaseOrderStatus.cancelled:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurchaseOrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
