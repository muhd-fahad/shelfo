// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleAdapter extends TypeAdapter<Sale> {
  @override
  final typeId = 9;

  @override
  Sale read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sale(
      id: fields[0] as String,
      dateTime: fields[1] as DateTime,
      customerName: fields[2] as String,
      items: (fields[3] as List).cast<SaleItem>(),
      subtotal: (fields[4] as num).toDouble(),
      taxAmount: (fields[5] as num).toDouble(),
      total: (fields[6] as num).toDouble(),
      paymentMethod: fields[7] as String,
      status: fields[8] == null ? 'Paid' : fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Sale obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.dateTime)
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
      ..write(obj.paymentMethod)
      ..writeByte(8)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
