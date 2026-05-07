import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/sfo_common/sfo_pos_card.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';
import 'package:shelfo/models/product/product_model.dart';

import 'package:shelfo/provider/pos_provider.dart';
import 'package:shelfo/screens/pos/pos_ui.dart';

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
      return const Center(child: Text("No products found"));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 174.5 / 254.5,
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
  }
}
