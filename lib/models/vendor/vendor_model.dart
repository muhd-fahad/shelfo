import 'package:hive_ce/hive.dart';

part 'vendor_model.g.dart';

@HiveType(typeId: 16)
class Vendor extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String companyName;

  @HiveField(2)
  final String? contactPerson;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? phone;

  @HiveField(5)
  final String? address;

  @HiveField(6)
  final String? category;

  @HiveField(7)
  final double dueAmount;

  @HiveField(8)
  final DateTime createdAt;

  Vendor({
    required this.id,
    required this.companyName,
    this.contactPerson,
    this.email,
    this.phone,
    this.address,
    this.category,
    this.dueAmount = 0.0,
    required this.createdAt,
  });

  Vendor copyWith({
    String? id,
    String? companyName,
    String? contactPerson,
    String? email,
    String? phone,
    String? address,
    String? category,
    double? dueAmount,
    DateTime? createdAt,
  }) {
    return Vendor(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      contactPerson: contactPerson ?? this.contactPerson,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      category: category ?? this.category,
      dueAmount: dueAmount ?? this.dueAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
