import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/category/category_model.dart';
import '../../provider/inventory/category_provider.dart';
import '../../screens/settings/edit_category_screen.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_search_bar.dart';

class CategorySelectionSheet extends StatelessWidget {
  const CategorySelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoryProvider = context.watch<CategoryProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: SFOSearchBar(
                  hintText: "Search category...",
                  onChanged: (val) => categoryProvider.setSearchQuery(val),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton.filled(
                onPressed: () async {
                  final newCategory = await Navigator.push<Category>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditCategoryScreen(),
                    ),
                  );
                  if (newCategory != null && context.mounted) {
                    Navigator.pop(context, newCategory);
                  }
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400.h,
          child: categoryProvider.categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No categories found",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () async {
                          final newCategory = await Navigator.push<Category>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditCategoryScreen(),
                            ),
                          );
                          if (newCategory != null && context.mounted) {
                            Navigator.pop(context, newCategory);
                          }
                        },
                        child: const Text("Create New Category"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(category.icon, color: AppColors.primary, size: 20.r),
                        ),
                        title: Text(
                          category.name,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pop(context, category);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
