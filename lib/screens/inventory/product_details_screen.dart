import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_price_row.dart';
import 'package:shelfo/widgets/sfo_common/sfo_metric_card.dart';
import 'package:shelfo/widgets/inventory/stock_adjustment_dialog.dart';
import 'package:shelfo/widgets/inventory/product_image_carousel.dart';
import 'package:shelfo/screens/inventory/edit_product_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currency = Provider.of<BusinessProvider>(context).selectedCurrency;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: isDark ? Colors.white : Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_outlined, color: isDark ? Colors.white : Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProductScreen(product: product)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          // Find the updated product in the provider's list if it was edited
          final currentProduct = provider.products.firstWhere((p) => p.id == product.id, orElse: () => product);
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Product Header
                Center(
                  child: Column(
                    children: [
                      ProductImageCarousel(
                        imagePaths: currentProduct.imagePaths ?? [],
                        isDark: isDark,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        currentProduct.name,
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentProduct.sku ?? "",
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SFOBadge(
                            label: currentProduct.categoryName ?? "Uncategorized",
                            bgColor: isDark ? AppColors.darkSurface : AppColors.surface,
                          ),
                          const SizedBox(width: 8),
                          SFOBadge(
                            label: currentProduct.productType.label,
                            bgColor: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue.shade50,
                            textColor: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Stock Info Row
                Row(
                  children: [
                    SFOMetricCard(label: "Current", value: currentProduct.stockQuantity.toString(), isDark: isDark),
                    const SizedBox(width: 12),
                    SFOMetricCard(label: "Min Level", value: currentProduct.minStock.toString(), isDark: isDark),
                    const SizedBox(width: 12),
                    SFOMetricCard(label: "Reorder At", value: currentProduct.reorderPoint.toString(), isDark: isDark),
                  ],
                ),

                const SizedBox(height: 20),

                // Pricing Card
                SFOCard(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const Text("Pricing", style: TextStyle(color: AppColors.textMuted, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SFOPriceRow(label: "Cost Price", value: CurrencyFormatter.format(currentProduct.costPrice, currency), isDark: isDark),
                    const SizedBox(height: 12),
                    SFOPriceRow(label: "Selling Price", value: CurrencyFormatter.format(currentProduct.price, currency), isDark: isDark, isPrimary: true),
                    const SizedBox(height: 12),
                    SFOPriceRow(label: "Margin", value: "${_calculateMargin(currentProduct)}%", isDark: isDark),
                  ],
                ),

                const SizedBox(height: 32),

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
                    const SizedBox(width: 16),
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
    showDialog(
      context: context,
      builder: (context) => StockAdjustmentDialog(
        product: product,
        provider: provider,
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
