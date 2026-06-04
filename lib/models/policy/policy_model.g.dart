// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'policy_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PolicyAdapter extends TypeAdapter<Policy> {
  @override
  final typeId = 23;

  @override
  Policy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Policy(
      id: fields[0] as String,
      name: fields[1] as String,
      type: fields[2] as PolicyType,
      durationDays: (fields[3] as num).toInt(),
      description: fields[4] as String,
      conditions: (fields[5] as List).cast<String>(),
      isActive: fields[6] == null ? true : fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Policy obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.durationDays)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.conditions)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolicyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PolicyTypeAdapter extends TypeAdapter<PolicyType> {
  @override
  final typeId = 22;

  @override
  PolicyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PolicyType.warranty;
      case 1:
        return PolicyType.returnPolicy;
      case 2:
        return PolicyType.service;
      default:
        return PolicyType.warranty;
    }
  }

  @override
  void write(BinaryWriter writer, PolicyType obj) {
    switch (obj) {
      case PolicyType.warranty:
        writer.writeByte(0);
      case PolicyType.returnPolicy:
        writer.writeByte(1);
      case PolicyType.service:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PolicyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
