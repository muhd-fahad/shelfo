import 'package:flutter/material.dart';
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
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          decoration: BoxDecoration(
            color: theme.cardTheme.color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                const SizedBox(height: 24),
                
                _buildSectionTitle(theme, colorScheme, "Category"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: productProvider.selectedFilterCategory == null,
                      onSelected: (val) => productProvider.setFilterCategory(null),
                    ),
                    ...categoryProvider.categories.map((c) => SFOChip(
                          label: c.name,
                          isSelected: productProvider.selectedFilterCategory == c.name,
                          onSelected: (val) => productProvider.setFilterCategory(c.name),
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(theme, colorScheme, "Brand"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: productProvider.selectedFilterBrand == null,
                      onSelected: (val) => productProvider.setFilterBrand(null),
                    ),
                    ...brandProvider.brands.take(12).map((b) => SFOChip(
                          label: b.name,
                          isSelected: productProvider.selectedFilterBrand == b.name,
                          onSelected: (val) => productProvider.setFilterBrand(b.name),
                        )),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(theme, colorScheme, "Stock Status"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["All", "In Stock", "Low Stock", "Out of Stock"].map((status) => SFOChip(
                    label: status,
                    isSelected: productProvider.stockStatus == status,
                    onSelected: (val) => productProvider.setStockStatus(status),
                  )).toList(),
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(theme, colorScheme, "Product Type"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: productProvider.selectedFilterProductType == null,
                      onSelected: (val) => productProvider.setFilterProductType(null),
                    ),
                    ...ProductType.values.map((type) => SFOChip(
                      label: type.label,
                      isSelected: productProvider.selectedFilterProductType == type,
                      onSelected: (val) => productProvider.setFilterProductType(type),
                    )),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(theme, colorScheme, "Price Range"),
                const SizedBox(height: 12),
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
                    const SizedBox(width: 16),
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

                const SizedBox(height: 40),
                SFOButton(
                  text: "Apply Filter",
                  onPressed: () {
                    final min = double.tryParse(productProvider.minPriceController.text);
                    final max = double.tryParse(productProvider.maxPriceController.text);
                    productProvider.setPriceRange(min, max);
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 16),
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
