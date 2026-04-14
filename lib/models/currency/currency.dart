import 'package:hive_ce/hive.dart';

part 'currency.g.dart';

@HiveType(typeId: 1)
enum Currency {
  @HiveField(0)
  inr('INR', '₹'),
  @HiveField(1)
  usd('USD', '\$'),
  @HiveField(2)
  eur('EUR', '€'),
  @HiveField(3)
  gbp('GBP', '£');

  final String code;
  final String symbol;

  const Currency(this.code, this.symbol);
}
