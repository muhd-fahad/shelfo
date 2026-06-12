import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/screens/settings/edit_category_screen.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';
import '../../models/category/category_model.dart';

class CategoriesSettingsScreen extends StatelessWidget {
  const CategoriesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: const SFOHeader(
        title: "Product Categories",
        subtitle: "Organize your products",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const EditCategoryScreen(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
      body: categoryProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.all(20.r),
              itemCount: categoryProvider.categories.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final category = categoryProvider.categories[index];
                return Material(
                  color: theme.cardTheme.color,
                  shape: theme.cardTheme.shape!,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                    leading: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        category.icon,
                        color: colorScheme.primary,
                        size: 22.r,
                      ),
                    ),
                    title: Text(
                      category.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: category.description != null && category.description!.isNotEmpty
                        ? Text(
                            category.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 20.r,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCategoryScreen(category: category),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, size: 20.r, color: AppColors.error),
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
