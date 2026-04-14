import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/category/category_model.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';

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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Initialize provider data when building the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).initCategory(category);
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category == null ? "Add Category" : "Edit Category",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              category == null ? "Create a new product category" : "Update category details",
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SFOCard(
                padding: const EdgeInsets.all(20),
                children: [
                  SFOInputField(
                    label: "Category Name",
                    hint: "e.g. Smartphones",
                    controller: provider.nameController,
                  ),
                  const SizedBox(height: 20),
                  SFOInputField(
                    label: "Description",
                    hint: "e.g. Mobile devices and phones",
                    controller: provider.descController,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Select Icon",
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),
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
                                color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
                                shape: RoundedSuperellipseBorder(
                                  borderRadius: AppRadius.sm,
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected ? AppColors.primary : (isDark ? AppColors.darkTextSecondary : AppColors.textSecondary),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SFOButton(
                text: category == null ? "Create Category" : "Save Changes",
                onPressed: () => _save(context, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, CategoryProvider provider) async {
    if (provider.nameController.text.isEmpty) {
      SFOSnackbar.show(
        context,
        message: "Please enter a category name",
        isError: true,
      );
      return;
    }

    await provider.saveCategory(category);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
