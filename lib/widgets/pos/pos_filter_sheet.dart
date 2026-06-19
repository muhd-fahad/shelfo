import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/inventory/brand_provider.dart';
import '../../provider/inventory/category_provider.dart';
import '../../provider/sales/pos_provider.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_input_field.dart';
import '../sfo_common/sfo_chip.dart';

class PosFilterSheet extends StatelessWidget {
  const PosFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer3<PosProvider, CategoryProvider, BrandProvider>(
      builder: (context, posProvider, categoryProvider, brandProvider, child) {
        return Container(
          padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 24.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
          ),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: posProvider.filterFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Filter Products",
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          posProvider.clearFilters();
                          Navigator.pop(context);
                        },
                        child: const Text("Clear All", style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  
                  _buildSectionTitle(theme, colorScheme, "Category"),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      SFOChip(
                        label: "All",
                        isSelected: posProvider.selectedCategories.isEmpty,
                        onSelected: (val) => posProvider.toggleCategory(null),
                      ),
                      ...categoryProvider.categories.map((c) => SFOChip(
                        label: c.name,
                        isSelected: posProvider.selectedCategories.contains(c.name),
                        onSelected: (val) => posProvider.toggleCategory(c.name),
                      )),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  _buildSectionTitle(theme, colorScheme, "Brand"),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      SFOChip(
                        label: "All",
                        isSelected: posProvider.selectedBrands.isEmpty,
                        onSelected: (val) => posProvider.toggleBrand(null),
                      ),
                      ...brandProvider.brands.take(12).map((b) => SFOChip(
                        label: b.name,
                        isSelected: posProvider.selectedBrands.contains(b.name),
                        onSelected: (val) => posProvider.toggleBrand(b.name),
                      )),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  _buildSectionTitle(theme, colorScheme, "Stock Status"),
                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: ["All", "In Stock", "Out of Stock"].map((status) => SFOChip(
                      label: status,
                      isSelected: status == "All" 
                          ? posProvider.stockStatuses.isEmpty 
                          : posProvider.stockStatuses.contains(status),
                      onSelected: (val) => posProvider.toggleStockStatus(status),
                    )).toList(),
                  ),
                  SizedBox(height: 24.h),

                  _buildSectionTitle(theme, colorScheme, "Price Range"),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SFOInputField(
                          label: "Min",
                          hint: "0",
                          controller: posProvider.minPriceController,
                          keyboardType: TextInputType.number,
                          onChanged: (val) => posProvider.filterFormKey.currentState?.validate(),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: SFOInputField(
                          label: "Max",
                          hint: "99999",
                          controller: posProvider.maxPriceController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) return null;
                            final max = double.tryParse(value);
                            final min = double.tryParse(posProvider.minPriceController.text) ?? 0.0;
                            if (max != null && max < min) {
                              return "Must be ≥ min price";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 40.h),
                  SFOButton(
                    text: "Apply Filter",
                    onPressed: () {
                      if (posProvider.filterFormKey.currentState?.validate() ?? false) {
                        final min = double.tryParse(posProvider.minPriceController.text);
                        final max = double.tryParse(posProvider.maxPriceController.text);
                        posProvider.setPriceRange(min, max);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(ThemeData theme, ColorScheme colorScheme, String title) {
    return Text(title, 
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.bold, 
        color: colorScheme.onSurfaceVariant
      )
    );
  }
}
