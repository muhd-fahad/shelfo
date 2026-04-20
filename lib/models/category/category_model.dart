import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 5)
class Category extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? description;

  @HiveField(2)
  final int? iconCode; // Store IconData.codePoint

  Category({
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
      name: name ?? this.name,
      description: description ?? this.description,
      iconCode: iconCode ?? this.iconCode,
    );
  }

  static const List<IconData> availableIcons = [
    // General/Shop
    Icons.category_rounded,
    Icons.shopping_bag_rounded,
    Icons.shopping_cart_rounded,
    Icons.store_rounded,
    Icons.inventory_2_rounded,
    Icons.label_rounded,
    Icons.sell_rounded,
    // Electronics
    Icons.smartphone_rounded,
    Icons.phone_iphone_rounded,
    Icons.laptop_rounded,
    Icons.laptop_mac_rounded,
    Icons.desktop_windows_rounded,
    Icons.tablet_rounded,
    Icons.watch_rounded,
    Icons.headphones_rounded,
    Icons.earbuds_rounded,
    Icons.tv_rounded,
    Icons.camera_alt_rounded,
    Icons.mouse_rounded,
    Icons.keyboard_rounded,
    Icons.speaker_rounded,
    Icons.print_rounded,
    Icons.router_rounded,
    Icons.electrical_services_rounded,
    Icons.cable_rounded,
    Icons.battery_charging_full_rounded,
    Icons.memory_rounded,
    Icons.sd_card_rounded,
    Icons.home_max_rounded,
    Icons.videogame_asset_rounded,
    Icons.power_rounded,
  ];

  IconData get icon {
    if (iconCode == null) return Icons.category_rounded;
    return availableIcons.firstWhere(
      (icon) => icon.codePoint == iconCode,
      orElse: () => Icons.category_rounded,
    );
  }
}
