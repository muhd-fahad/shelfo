import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_divider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';
import 'package:shelfo/utils/theme/app_constants/radius.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';

import 'package:shelfo/screens/pos/pos_ui.dart';

class CartDetailsSheet extends StatelessWidget {
  const CartDetailsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final cartProvider = context.watch<CartProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SFOSectionHeader(title: "Items"),
              TextButton(
                onPressed: () => cartProvider.clearCart(),
                child: const Text("Clear All", style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: cartProvider.items.length,
              separatorBuilder: (_, __) => const SFODivider(),
              itemBuilder: (context, index) {
                final item = cartProvider.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainer,
                          borderRadius: AppRadius.sm,
                        ),
                        child: item.product.imagePaths?.isNotEmpty == true
                            ? ClipRRect(
                                borderRadius: AppRadius.sm,
                                child: Image.file(File(item.product.imagePaths!.first), fit: BoxFit.cover),
                              )
                            : Icon(Icons.inventory_2_outlined, size: 20, color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.product.name, style: theme.textTheme.titleSmall),
                            Text(CurrencyFormatter.format(item.product.price, currency), style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.read<CartProvider>().removeFromCart(item.product),
                            icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                          ),
                          Text(item.quantity.toString(), style: theme.textTheme.titleMedium),
                          IconButton(
                            onPressed: () => PosUI.addToCart(context, item.product),
                            icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Subtotal", style: theme.textTheme.bodyLarge),
                  Text(CurrencyFormatter.format(cartProvider.subtotal, currency), style: theme.textTheme.bodyLarge),
                ],
              ),
              if (cartProvider.taxAmount > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tax", style: theme.textTheme.bodyLarge),
                    Text(CurrencyFormatter.format(cartProvider.taxAmount, currency), style: theme.textTheme.bodyLarge),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              const SFODivider(),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    CurrencyFormatter.format(cartProvider.total, currency),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          SFOButton(
            text: "Complete Sale",
            onPressed: () => PosUI.completeSale(context),
          ),
        ],
      ),
    );
  }
}
