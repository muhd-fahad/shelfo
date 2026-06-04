// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesOrderAdapter extends TypeAdapter<SalesOrder> {
  @override
  final typeId = 20;

  @override
  SalesOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesOrder(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      customerName: fields[2] as String,
      items: (fields[3] as List).cast<SaleItem>(),
      subtotal: (fields[4] as num).toDouble(),
      taxAmount: (fields[5] as num).toDouble(),
      total: (fields[6] as num).toDouble(),
      status: fields[7] as SalesOrderStatus,
      notes: fields[8] as String?,
      isPaid: fields[9] == null ? false : fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SalesOrder obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.customerName)
      ..writeByte(3)
      ..write(obj.items)
      ..writeByte(4)
      ..write(obj.subtotal)
      ..writeByte(5)
      ..write(obj.taxAmount)
      ..writeByte(6)
      ..write(obj.total)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.notes)
      ..writeByte(9)
      ..write(obj.isPaid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SalesOrderStatusAdapter extends TypeAdapter<SalesOrderStatus> {
  @override
  final typeId = 21;

  @override
  SalesOrderStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SalesOrderStatus.all;
      case 1:
        return SalesOrderStatus.draft;
      case 2:
        return SalesOrderStatus.pending;
      case 3:
        return SalesOrderStatus.fulfilled;
      case 4:
        return SalesOrderStatus.inTransit;
      case 5:
        return SalesOrderStatus.cancelled;
      default:
        return SalesOrderStatus.all;
    }
  }

  @override
  void write(BinaryWriter writer, SalesOrderStatus obj) {
    switch (obj) {
      case SalesOrderStatus.all:
        writer.writeByte(0);
      case SalesOrderStatus.draft:
        writer.writeByte(1);
      case SalesOrderStatus.pending:
        writer.writeByte(2);
      case SalesOrderStatus.fulfilled:
        writer.writeByte(3);
      case SalesOrderStatus.inTransit:
        writer.writeByte(4);
      case SalesOrderStatus.cancelled:
        writer.writeByte(5);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesOrderStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
