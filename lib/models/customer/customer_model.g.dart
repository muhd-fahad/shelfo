// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerAdapter extends TypeAdapter<Customer> {
  @override
  final typeId = 12;

  @override
  Customer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Customer(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as CustomerType,
      email: fields[3] as String?,
      phone: fields[4] as String?,
      address: fields[5] as String?,
      creditLimit: (fields[6] as num).toDouble(),
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Customer obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.creditLimit)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomerTypeAdapter extends TypeAdapter<CustomerType> {
  @override
  final typeId = 11;

  @override
  CustomerType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return CustomerType.business;
      case 1:
        return CustomerType.individual;
      default:
        return CustomerType.business;
    }
  }

  @override
  void write(BinaryWriter writer, CustomerType obj) {
    switch (obj) {
      case CustomerType.business:
        writer.writeByte(0);
      case CustomerType.individual:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
