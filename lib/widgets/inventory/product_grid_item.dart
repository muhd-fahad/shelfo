import 'package:flutter/material.dart';
import '../../models/currency/currency.dart';
import '../../models/product/product_model.dart';
import '../../screens/inventory/product_details_screen.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../sfo_common/sfo_product_card.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final Currency currency;

  const ProductGridItem({
    super.key,
    required this.product,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return SFOProductCard(
      name: product.name,
      price: CurrencyFormatter.format(product.price, currency),
      stockCount: product.stockQuantity,
      sku: product.sku,
      imagePath: product.imagePaths != null && product.imagePaths!.isNotEmpty 
          ? product.imagePaths![0] 
          : null,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product)),
      ),
    );
  }
}
