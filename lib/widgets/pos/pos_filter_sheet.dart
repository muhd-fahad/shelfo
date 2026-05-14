import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/category_provider.dart';
import '../../provider/pos_provider.dart';
import '../../provider/brand_provider.dart';
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
                const SizedBox(height: 24),
                
                _buildSectionTitle(theme, colorScheme, "Category"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SFOChip(
                      label: "All",
                      isSelected: posProvider.selectedCategory == null,
                      onSelected: (val) => posProvider.setCategory(null),
                    ),
                    ...categoryProvider.categories.map((c) => SFOChip(
                      label: c.name,
                      isSelected: posProvider.selectedCategory == c.name,
                      onSelected: (val) => posProvider.setCategory(c.name),
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
                      isSelected: posProvider.selectedBrand == null,
                      onSelected: (val) => posProvider.setBrand(null),
                    ),
                    ...brandProvider.brands.take(12).map((b) => SFOChip(
                      label: b.name,
                      isSelected: posProvider.selectedBrand == b.name,
                      onSelected: (val) => posProvider.setBrand(b.name),
                    )),
                  ],
                ),
                const SizedBox(height: 24),

                _buildSectionTitle(theme, colorScheme, "Stock Status"),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ["All", "In Stock", "Out of Stock"].map((status) => SFOChip(
                    label: status,
                    isSelected: posProvider.stockStatus == status,
                    onSelected: (val) => posProvider.setStockStatus(status),
                  )).toList(),
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
                        controller: posProvider.minPriceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SFOInputField(
                        label: "Max",
                        hint: "99999",
                        controller: posProvider.maxPriceController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                SFOButton(
                  text: "Apply Filter",
                  onPressed: () {
                    final min = double.tryParse(posProvider.minPriceController.text);
                    final max = double.tryParse(posProvider.maxPriceController.text);
                    posProvider.setPriceRange(min, max);
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
