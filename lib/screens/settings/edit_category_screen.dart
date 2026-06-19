import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/category/category_model.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';

import '../../provider/inventory/category_provider.dart';

class EditCategoryScreen extends StatelessWidget {
  final Category? category;
  const EditCategoryScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Initialize provider data when building the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).initCategory(category);
    });

    return Scaffold(
      appBar: SFOHeader(
        title: category == null ? "Add Category" : "Edit Category",
        subtitle: category == null ? "Create a new product category" : "Update category details",
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Form(
            key: provider.formKey,
            child: Column(
              children: [
                SFOCard(
                  padding: EdgeInsets.all(20.r),
                  children: [
                    SFOInputField(
                      label: "Category Name",
                      hint: "e.g. Smartphones",
                      controller: provider.nameController,
                      isRequired: true,
                    ),
                    SizedBox(height: 20.h),
                    SFOInputField(
                      label: "Description",
                      hint: "e.g. Mobile devices and phones",
                      controller: provider.descController,
                      maxLines: 3,
                    ),
                    SizedBox(height: 24.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Select Icon",
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                          ),
                          itemCount: Category.availableIcons.length,
                          itemBuilder: (context, index) {
                            final icon = Category.availableIcons[index];
                            final isSelected = provider.selectedIconCode == icon.codePoint;
                            return InkWell(
                              onTap: () => provider.setIconCode(icon.codePoint),
                              borderRadius: BorderRadius.circular(12.r),
                              child: Container(
                                decoration: ShapeDecoration(
                                  color: isSelected ? colorScheme.primary.withValues(alpha:0.05) : Colors.transparent,
                                  shape: RoundedSuperellipseBorder(
                                    borderRadius: AppRadius.sm,
                                    side: BorderSide(
                                      color: isSelected ? colorScheme.primary : colorScheme.outline,
                                      width: isSelected ? 2 : 1,
                                    ),
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  size: 24.r,
                                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                SFOButton(
                  text: category == null ? "Create Category" : "Save Changes",
                  onPressed: () => _save(context, provider),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, CategoryProvider provider) async {
    if (provider.formKey.currentState?.validate() ?? false) {
      final success = await provider.saveCategory(category);

      if (context.mounted) {
        if (!success) {
          SFOSnackbar.show(
            context,
            message: "Category with this name already exists",
            isError: true,
          );
        } else {
          Navigator.pop(context);
        }
      }
    }
  }
}
