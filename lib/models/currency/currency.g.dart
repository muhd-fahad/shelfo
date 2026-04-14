// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyAdapter extends TypeAdapter<Currency> {
  @override
  final typeId = 1;

  @override
  Currency read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Currency.inr;
      case 1:
        return Currency.usd;
      case 2:
        return Currency.eur;
      case 3:
        return Currency.gbp;
      default:
        return Currency.inr;
    }
  }

  @override
  void write(BinaryWriter writer, Currency obj) {
    switch (obj) {
      case Currency.inr:
        writer.writeByte(0);
      case Currency.usd:
        writer.writeByte(1);
      case Currency.eur:
        writer.writeByte(2);
      case Currency.gbp:
        writer.writeByte(3);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
