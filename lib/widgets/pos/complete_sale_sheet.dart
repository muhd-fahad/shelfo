import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/sale_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dropdown.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';

class CompleteSaleSheet extends StatelessWidget {
  const CompleteSaleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final cartProvider = context.watch<CartProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.xl,
        right: AppSpacing.xl,
        top: AppSpacing.xl,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.xl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Complete Sale",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () {
                  cartProvider.resetCheckout();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          
          SFODropdown<String>(
            label: "Customer (Optional)",
            value: cartProvider.selectedCustomer,
            items: const [
              DropdownMenuItem(value: "Walk-in Customer", child: Text("Walk-in Customer")),
            ],
            onChanged: (val) {
              if (val != null) cartProvider.setCustomer(val);
            },
          ),
          const SizedBox(height: AppSpacing.xl),

          Text(
            "Payment Method",
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              _PaymentMethodCard(
                label: "Cash",
                icon: Icons.payments_outlined,
                isSelected: cartProvider.selectedPaymentMethod == 'Cash',
                onTap: () => cartProvider.setPaymentMethod('Cash'),
              ),
              const SizedBox(width: AppSpacing.md),
              _PaymentMethodCard(
                label: "Card",
                icon: Icons.credit_card,
                isSelected: cartProvider.selectedPaymentMethod == 'Card',
                onTap: () => cartProvider.setPaymentMethod('Card'),
              ),
              const SizedBox(width: AppSpacing.md),
              _PaymentMethodCard(
                label: "E-Wallet",
                icon: Icons.smartphone,
                isSelected: cartProvider.selectedPaymentMethod == 'E-Wallet',
                onTap: () => cartProvider.setPaymentMethod('E-Wallet'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          if (cartProvider.selectedPaymentMethod == 'Cash') ...[
            SFOInputField(
              label: "Amount Tendered",
              hint: "0.00",
              controller: cartProvider.amountTenderedController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total Due:", style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text(
                  CurrencyFormatter.format(cartProvider.total, currency),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Change:", style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
                Text(
                  CurrencyFormatter.format(cartProvider.change > 0 ? cartProvider.change : 0, currency),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cartProvider.change > 0 ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          SFOButton(
            text: "Confirm Payment",
            icon: Icons.check_circle_outline,
            iconTrailing: true,
            backgroundColor: isDark ? colorScheme.onSurface.withValues(alpha: 0.1) : AppColors.textPrimary,
            onPressed: () => _confirmPayment(context, cartProvider),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmPayment(BuildContext context, CartProvider cartProvider) async {
    final productProvider = context.read<ProductProvider>();
    final saleProvider = context.read<SaleProvider>();
    final tendered = double.tryParse(cartProvider.amountTenderedController.text) ?? 0.0;

    if (cartProvider.selectedPaymentMethod == 'Cash' && tendered < cartProvider.total) {
       SFOSnackbar.show(context, message: "Tendered amount is less than total due!", isError: true);
       return;
    }

    final invoiceId = await saleProvider.getNextInvoiceId();
    await cartProvider.completeSale(productProvider, invoiceId);
    await saleProvider.loadSales(); // Refresh sales history

    if (context.mounted) {
      Navigator.pop(context); // Close CompleteSaleSheet
      Navigator.pop(context); // Close CartDetailsSheet
      SFOSnackbar.show(context, message: "Sale completed successfully!");
    }
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: ShapeDecoration(
            color: isSelected 
                ? (isDark ? colorScheme.primary.withValues(alpha: 0.1) : AppColors.primaryLight) 
                : (isDark ? AppColors.darkSurface : AppColors.white),
            shape: RoundedSuperellipseBorder(
              borderRadius: AppRadius.md,
              side: BorderSide(
                color: isSelected ? colorScheme.primary : colorScheme.outline,
                width: isSelected ? 1.5 : 1,
              ),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
