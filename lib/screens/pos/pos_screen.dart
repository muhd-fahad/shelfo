import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/pos_provider.dart';
import '../../widgets/pos/pos_filter_sheet.dart';
import 'pos_ui.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';

import 'package:shelfo/widgets/pos/cart_details_sheet.dart';
import '../../widgets/pos/category_filter_bar.dart';
import '../../widgets/pos/pos_product_grid.dart';

import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final posProvider = context.read<PosProvider>();

    return Scaffold(
      appBar: const SFOHeader(
        leading: null,
        title: "Point of Sale",
      ),
      floatingActionButton: cartProvider.items.isNotEmpty && !SFOResponsive.isDesktop(context)
          ? FloatingActionButton.extended(
              heroTag: null,
              onPressed: () => PosUI.showCartDetails(context),
              label: Text("Cart (${cartProvider.itemCount})"),
              icon: const Icon(Icons.shopping_basket_outlined),
            )
          : null,
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildMainContent(context, posProvider),
          desktop: Row(
            children: [
              Expanded(flex: 3, child: _buildMainContent(context, posProvider)),
              const VerticalDivider(width: 1),
              Expanded(
                flex: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  child: const CartDetailsSheet(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, PosProvider posProvider) {
    return Column(
      children: [
        // Search and Filters
        Padding(
          padding: EdgeInsets.fromLTRB(
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
        SizedBox(height: AppSpacing.lg),
        const CategoryFilterBar(),

        SizedBox(height: AppSpacing.lg),

        // Product Grid
        const Expanded(
          child: PosProductGrid(),
        ),
      ],
    );
  }
}
