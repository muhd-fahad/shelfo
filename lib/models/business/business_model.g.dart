// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessAdapter extends TypeAdapter<Business> {
  @override
  final typeId = 0;

  @override
  Business read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Business(
      name: fields[0] as String,
      phoneNumber: fields[1] as String,
      address: fields[2] as String,
      logoPath: fields[3] as String?,
      currency: fields[4] as Currency,
    );
  }

  @override
  void write(BinaryWriter writer, Business obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.logoPath)
      ..writeByte(4)
      ..write(obj.currency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
