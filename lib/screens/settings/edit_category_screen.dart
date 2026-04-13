import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/category/category_model.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';

class EditCategoryScreen extends StatelessWidget {
  final Category? category;
  const EditCategoryScreen({super.key, this.category});

  static const List<IconData> _availableIcons = [
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

  @override
  Widget build(BuildContext context) {
    // Initialize provider data when building the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).initCategory(category);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(category == null ? "Add Category" : "Edit Category"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Consumer<CategoryProvider>(
              builder: (context, provider, _) => TextButton(
                onPressed: () => _save(context, provider),
                child: const Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24,
            children: [
              InputWidget(
                title: "Category Name",
                hint: "e.g. Smartphones",
                controller: provider.nameController,
              ),
              InputWidget(
                title: "Description",
                hint: "e.g. Mobile devices and phones",
                controller: provider.descController,
                maxLines: 3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    "Select Icon",
                    style: SFOAppTheme.light.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: _availableIcons.length,
                    itemBuilder: (context, index) {
                      final icon = _availableIcons[index];
                      final isSelected = provider.selectedIconCode == icon.codePoint;
                      return InkWell(
                        onTap: () => provider.setIconCode(icon.codePoint),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: ShapeDecoration(
                            color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                            shape: RoundedSuperellipseBorder(
                              borderRadius: AppRadius.sm,
                              side: BorderSide(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                          ),
                          child: Icon(
                            icon,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, CategoryProvider provider) async {
    if (provider.nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a category name")),
      );
      return;
    }

    await provider.saveCategory(category);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
