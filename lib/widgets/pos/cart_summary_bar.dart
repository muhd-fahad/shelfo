import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/utils/theme/app_constants/colors.dart';
import 'package:shelfo/utils/theme/app_constants/spacing.dart';

import 'package:shelfo/screens/pos/pos_ui.dart';

class CartSummaryBar extends StatelessWidget {
  const CartSummaryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cartProvider = context.watch<CartProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    if (cartProvider.items.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${cartProvider.itemCount} Items Total",
                  style: theme.textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(cartProvider.total, currency),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SFOButton(
              text: "Review Order",
              width: 160,
              icon: Icons.arrow_forward_rounded,
              onPressed: () => PosUI.showCartDetails(context),
            ),
          ],
        ),
      ),
    );
  }
}
