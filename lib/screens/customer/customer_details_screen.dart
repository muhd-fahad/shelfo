import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/customer/customer_model.dart';
import '../../provider/business_provider.dart';
import '../../provider/customer_provider.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_badge.dart';
import '../../widgets/sfo_common/sfo_metric_card.dart';
import '../../widgets/sfo_common/sfo_dialog.dart';
import 'add_edit_customer_screen.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailsScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    // Initialize the provider with the ID
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerProvider>().setSelectedCustomer(customerId);
    });

    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final businessProvider = context.read<BusinessProvider>();
        final currency = businessProvider.selectedCurrency;

        final customer = provider.selectedCustomer;
        final customerSales = provider.customerSales;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditCustomerScreen(customer: customer),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _showDeleteDialog(context, provider),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                        child: Text(
                          customer.name.substring(0, 2).toUpperCase(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customer.name,
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              customer.type == CustomerType.business ? "Business" : "Individual",
                              style: theme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Contact Info Card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: ShapeDecoration(
                    color: theme.cardTheme.color,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: AppRadius.lg,
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                  child: Column(
                    children: [
                      _ContactRow(icon: Icons.email_outlined, text: customer.email ?? "No email"),
                      const SizedBox(height: AppSpacing.md),
                      _ContactRow(icon: Icons.phone_outlined, text: customer.phone ?? "No phone"),
                      const SizedBox(height: AppSpacing.md),
                      _ContactRow(icon: Icons.location_on_outlined, text: customer.address ?? "No address"),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Metrics
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Row(
                    children: [
                      Expanded(
                        child: SFOMetricCard(
                          label: "Total Purchases",
                          value: CurrencyFormatter.format(provider.totalPurchases, currency),
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SFOMetricCard(
                          label: "Outstanding",
                          value: CurrencyFormatter.format(provider.getOutstanding(customer), currency),
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: SFOMetricCard(
                          label: "Credit Limit",
                          value: CurrencyFormatter.format(customer.creditLimit, currency),
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Order History
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Row(
                    children: [
                      Text(
                        "Order History (",
                        style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        "${customerSales.length}",
                        style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                      Text(
                        ")",
                        style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: customerSales.length,
                  separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                  itemBuilder: (context, index) {
                    final sale = customerSales[index];
                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: ShapeDecoration(
                        color: theme.cardTheme.color,
                        shape: RoundedSuperellipseBorder(
                          borderRadius: AppRadius.md,
                          side: BorderSide(color: colorScheme.outlineVariant),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.shopping_cart_outlined, size: 20, color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(sale.id, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                                Text(DateFormat('MMM dd, yyyy').format(sale.dateTime), style: theme.textTheme.labelSmall),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(sale.total, currency),
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          SFOBadge(
                            label: sale.status,
                            bgColor: sale.status == 'Refunded'
                                ? AppColors.error.withValues(alpha: 0.1)
                                : AppColors.success.withValues(alpha: 0.1),
                            textColor: sale.status == 'Refunded' ? AppColors.error : AppColors.success,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, CustomerProvider provider) {
    showDialog(
      context: context,
      builder: (context) => SFODialog(
        title: "Delete Customer",
        message: "Are you sure you want to delete ${provider.selectedCustomer.name}? This action cannot be undone.",
        primaryActionText: "Delete",
        onPrimaryAction: () async {
          await provider.deleteCustomer(customerId);
          if (context.mounted) {
            Navigator.pop(context); // Close dialog
            Navigator.pop(context); // Go back to list
          }
        },
        secondaryActionText: "Cancel",
        isDestructive: true,
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
