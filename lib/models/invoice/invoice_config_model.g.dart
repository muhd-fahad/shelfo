// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceConfigAdapter extends TypeAdapter<InvoiceConfig> {
  @override
  final typeId = 4;

  @override
  InvoiceConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceConfig(
      prefix: fields[0] as String,
      startingNumber: (fields[1] as num).toInt(),
      footerText: fields[2] as String,
      showLogo: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.prefix)
      ..writeByte(1)
      ..write(obj.startingNumber)
      ..writeByte(2)
      ..write(obj.footerText)
      ..writeByte(3)
      ..write(obj.showLogo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
