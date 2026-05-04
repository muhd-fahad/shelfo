import 'package:hive_ce/hive.dart';

part 'brand_model.g.dart';

@HiveType(typeId: 8)
class Brand extends HiveObject {
  @HiveField(0)
  final String name;

  Brand({
    required this.name,
  });

  Brand copyWith({
    String? name,
  }) {
    return Brand(
      name: name ?? this.name,
    );
  }
}
