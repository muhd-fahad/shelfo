import 'package:flutter/material.dart';
import '../../provider/category_provider.dart';
import '../../provider/product_provider.dart';
import '../../utils/theme/theme.dart';
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
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
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
                  productProvider.setFilterCategory(null);
                  Navigator.pop(context);
                },
                child: const Text("Clear All", style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text("Category", 
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold, 
              color: colorScheme.onSurfaceVariant
            )
          ),
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: onSelected,
      backgroundColor: colorScheme.surface,
      selectedColor: colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(
        color: isSelected ? colorScheme.primary : colorScheme.outline,
      ),
      showCheckmark: false,
    );
  }
}
