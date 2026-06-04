import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_price_row.dart';
import 'package:shelfo/widgets/sfo_common/sfo_metric_card.dart';
import 'package:shelfo/widgets/inventory/stock_adjustment_dialog.dart';
import 'package:shelfo/widgets/inventory/product_image_carousel.dart';
import 'package:shelfo/screens/inventory/edit_product_screen.dart';

import '../../widgets/sfo_common/sfo_header.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currency = Provider.of<BusinessProvider>(context).selectedCurrency;

    return Scaffold(
      appBar: SFOHeader(
        title: product.name,
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: colorScheme.onSurface),
            onPressed: () {
              final freshProduct = Provider.of<ProductProvider>(context, listen: false)
                  .products.firstWhere((p) => p.id == product.id, orElse: () => product);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProductScreen(product: freshProduct)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
            onPressed: () => _confirmDelete(context),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          final currentProduct = provider.products.firstWhere((p) => p.id == product.id, orElse: () => product);
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                // Product Header
                ProductImageCarousel(
                  imagePaths: currentProduct.imagePaths ?? [],
                ),
                SizedBox(height: 24.h),
                Text(
                  currentProduct.name,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                Text(
                  currentProduct.sku ?? "",
                  style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SFOBadge(
                      label: currentProduct.categoryName ?? "Uncategorized",
                    ),
                    SizedBox(width: 8.w),
                    SFOBadge(
                      label: currentProduct.productType.label,
                      bgColor: colorScheme.primary.withOpacity(0.1),
                      textColor: colorScheme.primary,
                    ),
                  ],
                ),
                if (currentProduct.description != null && currentProduct.description!.isNotEmpty) ...[
                  SizedBox(height: 24.h),
                  Text(
                    currentProduct.description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],

                SizedBox(height: 32.h),

                // Stock Info Row
                Row(
                  children: [
                    SFOMetricCard(label: "Current", value: currentProduct.stockQuantity.toString()),
                    SizedBox(width: 12.w),
                    SFOMetricCard(label: "Min Level", value: currentProduct.minStock.toString()),
                    SizedBox(width: 12.w),
                    SFOMetricCard(label: "Reorder At", value: currentProduct.reorderPoint.toString()),
                  ],
                ),

                SizedBox(height: 20.h),

                // Pricing Card
                SFOCard(
                  padding: EdgeInsets.all(20.r),
                  children: [
                    Text("Pricing", style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16.h),
                    SFOPriceRow(label: "Cost Price", value: CurrencyFormatter.format(currentProduct.costPrice, currency)),
                    SizedBox(height: 12.h),
                    SFOPriceRow(label: "Selling Price", value: CurrencyFormatter.format(currentProduct.price, currency), isPrimary: true),
                    SizedBox(height: 12.h),
                    SFOPriceRow(label: "Margin", value: "${_calculateMargin(currentProduct)}%"),
                  ],
                ),

                SizedBox(height: 32.h),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: SFOButton(
                        text: "Add Stock",
                        icon: Icons.add,
                        onPressed: () => _showStockDialog(context, provider, currentProduct, true),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: SFOButton(
                        text: "Remove",
                        icon: Icons.inventory_2_outlined,
                        type: SFOButtonType.outlined,
                        isSecondary: true,
                        onPressed: () => _showStockDialog(context, provider, currentProduct, false),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _calculateMargin(Product p) {
    if (p.price == 0) return "0";
    final margin = ((p.price - p.costPrice) / p.price) * 100;
    return margin.toStringAsFixed(0);
  }

  void _showStockDialog(BuildContext context, ProductProvider provider, Product product, bool isAddition) {
    provider.initStockAdjustment(product);
    showDialog(
      context: context,
      builder: (context) => StockAdjustmentDialog(
        product: product,
        isAddition: isAddition,
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    SFODialog.show(
      context,
      title: "Delete Product",
      message: "Are you sure you want to delete this product?",
      primaryActionText: "Delete",
      isDestructive: true,
      onPrimaryAction: () {
        Provider.of<ProductProvider>(context, listen: false).deleteProduct(product);
        Navigator.pop(context);
        Navigator.pop(context);
      },
      secondaryActionText: "Cancel",
    );
  }
}
