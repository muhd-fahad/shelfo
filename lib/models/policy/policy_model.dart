import 'package:hive_ce/hive.dart';

part 'policy_model.g.dart';

@HiveType(typeId: 22)
enum PolicyType {
  @HiveField(0)
  warranty,
  @HiveField(1)
  returnPolicy,
  @HiveField(2)
  service,
}

extension PolicyTypeExtension on PolicyType {
  String get label {
    switch (this) {
      case PolicyType.warranty:
        return "Warranty";
      case PolicyType.returnPolicy:
        return "Return Policy";
      case PolicyType.service:
        return "Service";
    }
  }
}

@HiveType(typeId: 23)
class Policy extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final PolicyType type;

  @HiveField(3)
  final int durationDays;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final List<String> conditions;

  @HiveField(6)
  final bool isActive;

  @HiveField(7)
  final DateTime createdAt;

  Policy({
    required this.id,
    required this.name,
    required this.type,
    required this.durationDays,
    required this.description,
    required this.conditions,
    this.isActive = true,
    required this.createdAt,
  });

  Policy copyWith({
    String? id,
    String? name,
    PolicyType? type,
    int? durationDays,
    String? description,
    List<String>? conditions,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Policy(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      durationDays: durationDays ?? this.durationDays,
      description: description ?? this.description,
      conditions: conditions ?? this.conditions,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
