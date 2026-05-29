import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_model.dart';
import '../../provider/category_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/brand_provider.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_input_field.dart';
import '../sfo_common/sfo_chip.dart';

class InventoryFilterSheet extends StatelessWidget {
  const InventoryFilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Consumer3<ProductProvider, CategoryProvider, BrandProvider>(
      builder: (context, productProvider, categoryProvider, brandProvider, child) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Filter by",
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        productProvider.clearFilters();
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
                      isSelected: productProvider.selectedFilterCategories.isEmpty,
                      onSelected: (val) => productProvider.toggleFilterCategory(null),
                    ),
                    ...categoryProvider.categories.map((c) => SFOChip(
                          label: c.name,
                          isSelected: productProvider.selectedFilterCategories.contains(c.name),
                          onSelected: (val) => productProvider.toggleFilterCategory(c.name),
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
                      isSelected: productProvider.selectedFilterBrands.isEmpty,
                      onSelected: (val) => productProvider.toggleFilterBrand(null),
                    ),
                    ...brandProvider.brands.take(12).map((b) => SFOChip(
                          label: b.name,
                          isSelected: productProvider.selectedFilterBrands.contains(b.name),
                          onSelected: (val) => productProvider.toggleFilterBrand(b.name),
                        )),
                  ],
                ),
                SizedBox(height: 24.h),

                _buildSectionTitle(theme, colorScheme, "Stock Status"),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: ["All", "In Stock", "Low Stock", "Out of Stock"].map((status) => SFOChip(
                    label: status,
                    isSelected: status == "All" 
                        ? productProvider.stockStatuses.isEmpty 
                        : productProvider.stockStatuses.contains(status),
                    onSelected: (val) => productProvider.toggleStockStatus(status),
                  )).toList(),
                ),
                SizedBox(height: 24.h),

                _buildSectionTitle(theme, colorScheme, "Product Type"),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: productProvider.selectedFilterProductTypes.isEmpty,
                      onSelected: (val) => productProvider.toggleFilterProductType(null),
                    ),
                    ...ProductType.values.map((type) => SFOChip(
                      label: type.label,
                      isSelected: productProvider.selectedFilterProductTypes.contains(type),
                      onSelected: (val) => productProvider.toggleFilterProductType(type),
                    )),
                  ],
                ),
                SizedBox(height: 24.h),

                _buildSectionTitle(theme, colorScheme, "Price Range"),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: SFOInputField(
                        label: "Min",
                        hint: "0",
                        controller: productProvider.minPriceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SFOInputField(
                        label: "Max",
                        hint: "99999",
                        controller: productProvider.maxPriceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 40.h),
                SFOButton(
                  text: "Apply Filter",
                  onPressed: () {
                    final min = double.tryParse(productProvider.minPriceController.text);
                    final max = double.tryParse(productProvider.maxPriceController.text);
                    productProvider.setPriceRange(min, max);
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 16.h),
              ],
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
