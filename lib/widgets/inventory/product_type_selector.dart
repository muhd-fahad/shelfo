import 'package:flutter/material.dart';
import '../../models/product/product_model.dart';
import '../../utils/theme/theme.dart';

class ProductTypeSelector extends StatelessWidget {
  final ProductType selectedType;
  final Function(ProductType) onTypeSelected;

  const ProductTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 3.5,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: ProductType.values.map((type) {
        final isSelected = selectedType == type;
        return GestureDetector(
          onTap: () => onTypeSelected(type),
          child: Container(
            decoration: ShapeDecoration(
              color: isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.transparent,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  width: 1,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              type.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
