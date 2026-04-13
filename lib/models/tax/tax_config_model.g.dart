// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxConfigAdapter extends TypeAdapter<TaxConfig> {
  @override
  final typeId = 3;

  @override
  TaxConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaxConfig(
      isTaxEnabled: fields[0] as bool,
      defaultTaxRate: (fields[1] as num).toDouble(),
      taxLabel: fields[2] as String,
      pricingMode: fields[3] as TaxPricingMode,
    );
  }

  @override
  void write(BinaryWriter writer, TaxConfig obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.isTaxEnabled)
      ..writeByte(1)
      ..write(obj.defaultTaxRate)
      ..writeByte(2)
      ..write(obj.taxLabel)
      ..writeByte(3)
      ..write(obj.pricingMode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
