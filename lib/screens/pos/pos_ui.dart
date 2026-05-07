import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/widgets/sfo_common/sfo_bottom_sheet.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';
import '../../widgets/pos/cart_details_sheet.dart';

import '../../widgets/pos/complete_sale_sheet.dart';

class PosUI {
  static void showCartDetails(BuildContext context) {
    SFOBottomSheet.show(
      context,
      title: "Current Order",
      child: const CartDetailsSheet(),
    );
  }

  static Future<void> completeSale(BuildContext context) async {
    final cartProvider = context.read<CartProvider>();

    if (cartProvider.items.isEmpty) {
      SFOSnackbar.show(context, message: "Cart is empty!");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CompleteSaleSheet(),
    );
  }

  static void addToCart(BuildContext context, Product product) {
    final result = context.read<CartProvider>().addToCart(product);
    
    if (result == -1) {
      SFOSnackbar.show(
        context, 
        message: "${product.name} is out of stock!", 
        isError: true
      );
    } else {
      SFOSnackbar.show(
        context,
        message: result == 0 
          ? "${product.name} added to cart" 
          : "Updated ${product.name} quantity in cart",
      );
    }
  }
}
