// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_pricing_mode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxPricingModeAdapter extends TypeAdapter<TaxPricingMode> {
  @override
  final typeId = 2;

  @override
  TaxPricingMode read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaxPricingMode.exclusive;
      case 1:
        return TaxPricingMode.inclusive;
      default:
        return TaxPricingMode.exclusive;
    }
  }

  @override
  void write(BinaryWriter writer, TaxPricingMode obj) {
    switch (obj) {
      case TaxPricingMode.exclusive:
        writer.writeByte(0);
      case TaxPricingMode.inclusive:
        writer.writeByte(1);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxPricingModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
