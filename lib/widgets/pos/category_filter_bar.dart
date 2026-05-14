import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/provider/pos_provider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_chip.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';

class CategoryFilterBar extends StatelessWidget {
  const CategoryFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final posProvider = context.watch<PosProvider>();

    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        scrollDirection: Axis.horizontal,
        itemCount: categoryProvider.categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final categoryName = isAll ? "All" : categoryProvider.categories[index - 1].name;
          final isSelected = posProvider.selectedCategory == categoryName || 
                            (isAll && posProvider.selectedCategory == null);

          return SFOChip(
            label: categoryName,
            isSelected: isSelected,
            onSelected: (_) => posProvider.setCategory(isAll ? null : categoryName),
          );
        },
      ),
    );
  }
}
