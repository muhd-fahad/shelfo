import 'package:hive_ce/hive.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 11)
enum CustomerType {
  @HiveField(0)
  business,
  @HiveField(1)
  individual,
}

@HiveType(typeId: 12)
class Customer extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final CustomerType type;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? phone;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final double creditLimit;

  @HiveField(7)
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.type,
    this.email,
    this.phone,
    this.address,
    required this.creditLimit,
    required this.createdAt,
  });

  Customer copyWith({
    String? id,
    String? name,
    CustomerType? type,
    String? email,
    String? phone,
    String? address,
    double? creditLimit,
    DateTime? createdAt,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      creditLimit: creditLimit ?? this.creditLimit,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
