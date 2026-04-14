import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/screens/settings/edit_category_screen.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';
import '../../models/category/category_model.dart';

class CategoriesSettingsScreen extends StatelessWidget {
  const CategoriesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Categories"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditCategoryScreen(),
              ),
            ),
          ),
        ],
      ),
      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: categoryProvider.categories.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return Card(
                  elevation: 0,
                  shape: RoundedSuperellipseBorder(
                    borderRadius: AppRadius.md,
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        category.iconCode != null
                            ? IconData(category.iconCode!, fontFamily: 'MaterialIcons')
                            : Icons.category_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(category.name),
                    subtitle: category.description != null && category.description!.isNotEmpty
                        ? Text(category.description!)
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCategoryScreen(category: category),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.red),
                          onPressed: () => _showDeleteConfirmation(context, category),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Category category) {
    SFODialog.show(
      context,
      title: "Delete Category",
      message: "Are you sure you want to delete '${category.name}'?",
      primaryActionText: "Delete",
      onPrimaryAction: () {
        Provider.of<CategoryProvider>(context, listen: false).deleteCategory(category);
        Navigator.pop(context);
      },
      secondaryActionText: "Cancel",
      isDestructive: true,
    );
  }
}
