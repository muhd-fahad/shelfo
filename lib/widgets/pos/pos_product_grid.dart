import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/sfo_common/sfo_pos_card.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/models/product/product_model.dart';

import 'package:shelfo/screens/pos/pos_ui.dart';

import '../../provider/business/business_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../provider/sales/cart_provider.dart';
import '../../provider/sales/pos_provider.dart';
import '../sfo_common/sfo_empty_state.dart';

class PosProductGrid extends StatelessWidget {
  const PosProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = context.watch<ProductProvider>();
    final cartProvider = context.watch<CartProvider>();
    final posProvider = context.watch<PosProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    if (productProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final filteredProducts = posProvider.getFilteredProducts(productProvider);

    if (filteredProducts.isEmpty) {
      return const SFOEmptyState(
        title: "No products found",
        subtitle: "Try adjusting your filters or search query",
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isDesktop = constraints.maxWidth >= 1024;
        final bool isTablet = constraints.maxWidth >= 600;
        final int crossAxisCount = isDesktop ? 4 : (isTablet ? 3 : 2);

        return GridView.builder(
          padding: EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: 3/4,
            crossAxisSpacing: AppSpacing.lg,
            mainAxisSpacing: AppSpacing.lg,
          ),
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];

            // Calculate remaining stock based on cart
            final cartItemIndex = cartProvider.items.indexWhere((item) => item.product.id == product.id);
            final cartQuantity = cartItemIndex != -1 ? cartProvider.items[cartItemIndex].quantity : 0;
            final availableStock = product.stockQuantity - cartQuantity;

            final isInCart = cartQuantity > 0;

            String? badgeText;
            if (product.productType == ProductType.service) {
              badgeText = "Service";
            }

            return SFOPosCard(
              name: product.name,
              price: CurrencyFormatter.format(product.price, currency),
              stockCount: availableStock,
              badgeText: badgeText,
              imagePath: product.imagePaths?.isNotEmpty == true ? product.imagePaths!.first : null,
              isSelected: isInCart,
              onTap: () => PosUI.addToCart(context, product),
            );
          },
        );
      },
    );
  }
}
