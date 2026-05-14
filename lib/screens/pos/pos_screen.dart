import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/pos_provider.dart';
import '../../widgets/pos/pos_filter_sheet.dart';
import 'pos_ui.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';

import '../../widgets/pos/category_filter_bar.dart';
import '../../widgets/pos/pos_product_grid.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final posProvider = context.read<PosProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(
          title: "Point of Sale",
          // subtitle: "Select products for checkout",
        ),
        actions: [
          if (cartProvider.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xl),
              child: Badge.count(
                count: cartProvider.itemCount,
                child: SFOButton(
                  text: "Cart",
                  icon: Icons.shopping_basket_outlined,
                  width: 120,
                  onPressed: () => PosUI.showCartDetails(context),
                ),
              ),
            ),
        ],
      ),
      body: SFOBackground(
        child: Column(
          children: [
          // Search and Filters
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.xl,
              0,
            ),
            child: SFOSearchBar(
              controller: posProvider.searchController,
              hintText: "Search products...",
              onFilterTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => const PosFilterSheet(),
                );
              },
            ),
          ),

          // Categories
          const SizedBox(height: AppSpacing.lg),
          const CategoryFilterBar(),

          const SizedBox(height: AppSpacing.lg),

          // Product Grid
          const Expanded(
            child: PosProductGrid(),
          ),
        ],
      ),
    ),
  );
}
}
