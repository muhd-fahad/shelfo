import 'package:hive_ce/hive.dart';
import 'tax_pricing_mode.dart';

part 'tax_config_model.g.dart';

@HiveType(typeId: 3)
class TaxConfig {
  @HiveField(0)
  final bool isTaxEnabled;

  @HiveField(1)
  final double defaultTaxRate;

  @HiveField(2)
  final String taxLabel;

  @HiveField(3)
  final TaxPricingMode pricingMode;

  TaxConfig({
    required this.isTaxEnabled,
    required this.defaultTaxRate,
    required this.taxLabel,
    required this.pricingMode,
  });

  TaxConfig copyWith({
    bool? isTaxEnabled,
    double? defaultTaxRate,
    String? taxLabel,
    TaxPricingMode? pricingMode,
  }) {
    return TaxConfig(
      isTaxEnabled: isTaxEnabled ?? this.isTaxEnabled,
      defaultTaxRate: defaultTaxRate ?? this.defaultTaxRate,
      taxLabel: taxLabel ?? this.taxLabel,
      pricingMode: pricingMode ?? this.pricingMode,
    );
  }
}
