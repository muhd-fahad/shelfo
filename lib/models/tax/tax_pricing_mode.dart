import 'package:hive_ce/hive.dart';

part 'tax_pricing_mode.g.dart';

@HiveType(typeId: 2)
enum TaxPricingMode {
  @HiveField(0)
  exclusive,
  @HiveField(1)
  inclusive,
}
