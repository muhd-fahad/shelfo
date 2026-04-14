import 'package:hive_ce/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class Category extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final int? iconCode; // Store IconData.codePoint

  Category({
    required this.id,
    required this.name,
    this.description,
    this.iconCode,
  });

  Category copyWith({
    String? name,
    String? description,
    int? iconCode,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
    );
  }
}
