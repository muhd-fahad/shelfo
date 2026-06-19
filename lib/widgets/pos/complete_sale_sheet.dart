import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/customer/customer_model.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_bottom_sheet.dart';
import 'package:shelfo/widgets/customer/customer_selection_sheet.dart';

import '../../provider/business/business_provider.dart';
import '../../provider/customer/customer_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../provider/sales/cart_provider.dart';
import '../../provider/sales/sale_provider.dart';

class CompleteSaleSheet extends StatelessWidget {
  const CompleteSaleSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Consumer3<CartProvider, BusinessProvider, CustomerProvider>(
      builder: (context, cartProvider, businessProvider, customerProvider, child) {
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
              SizedBox(height: AppSpacing.xl),
              
              // Customer Selection (Matches Sales Order style)
              Text(
                "Customer",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 8.0.h),
              GestureDetector(
                onTap: () async {
                  context.read<CustomerProvider>().setSearchQuery(""); // Clear search
                  final customer = await SFOBottomSheet.show<Customer>(
                    context,
                    title: "Select Customer",
                    child: const CustomerSelectionSheet(),
                  );
                  if (customer != null) {
                    cartProvider.setCustomer(customer);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: colorScheme.primary),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cartProvider.selectedCustomer?.name ?? "Walk-in Customer",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: cartProvider.selectedCustomer != null 
                                  ? colorScheme.onSurface 
                                  : colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (cartProvider.selectedCustomer != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                "${cartProvider.selectedCustomer?.phone ?? 'No Phone'} • ${cartProvider.selectedCustomer?.address ?? 'No Address'}",
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              Text(
                "Payment Method",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  _PaymentMethodCard(
                    label: "Cash",
                    icon: Icons.payments_outlined,
                    isSelected: cartProvider.selectedPaymentMethod == 'Cash',
                    onTap: () => cartProvider.setPaymentMethod('Cash'),
                  ),
                  SizedBox(width: AppSpacing.md),
                  _PaymentMethodCard(
                    label: "Card",
                    icon: Icons.credit_card,
                    isSelected: cartProvider.selectedPaymentMethod == 'Card',
                    onTap: () => cartProvider.setPaymentMethod('Card'),
                  ),
                  SizedBox(width: AppSpacing.md),
                  _PaymentMethodCard(
                    label: "E-Wallet",
                    icon: Icons.smartphone,
                    isSelected: cartProvider.selectedPaymentMethod == 'E-Wallet',
                    onTap: () => cartProvider.setPaymentMethod('E-Wallet'),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xl),
              
              if (cartProvider.selectedPaymentMethod == 'Cash') ...[
                SFOInputField(
                  label: "Amount Tendered",
                  hint: "0.00",
                  controller: cartProvider.amountTenderedController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: AppSpacing.xl),
              ],

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

              if (cartProvider.selectedPaymentMethod == 'Cash') ...[
                SizedBox(height: AppSpacing.xs),
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
              ],
              
              SizedBox(height: AppSpacing.xl),
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
      },
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
          padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
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
              SizedBox(height: AppSpacing.xs),
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
