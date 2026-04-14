import 'package:hive_ce/hive.dart';
import '../currency/currency.dart';

part 'business_model.g.dart';


@HiveType(typeId: 0)
class Business {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String phoneNumber;

  @HiveField(2)
  final String address;

  @HiveField(3)
  final String? logoPath;

  @HiveField(4)
  final Currency currency;

  Business({
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.logoPath,
    required this.currency,
  });
}

