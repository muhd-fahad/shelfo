import 'package:flutter/material.dart';
import '../../provider/category_provider.dart';
import '../../provider/product_provider.dart';
import '../../utils/theme/theme_constants.dart';
import '../sfo_common/sfo_button.dart';

class InventoryFilterSheet extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final ProductProvider productProvider;

  const InventoryFilterSheet({
    super.key,
    required this.categoryProvider,
    required this.productProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter by",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  productProvider.setFilterCategory(null);
                  Navigator.pop(context);
                },
                child: const Text("Clear All", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text("Category", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(
                label: "All",
                isSelected: productProvider.selectedFilterCategory == null,
                onSelected: (val) {
                  productProvider.setFilterCategory(null);
                },
              ),
              ...categoryProvider.categories.map((c) => _FilterChip(
                    label: c.name,
                    isSelected: productProvider.selectedFilterCategory == c.name,
                    onSelected: (val) {
                      productProvider.setFilterCategory(c.name);
                    },
                  )),
            ],
          ),
          const SizedBox(height: 40),
          SFOButton(
            text: "Apply Filter",
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.surface,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(
        color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.border),
      ),
      showCheckmark: false,
    );
  }
}
