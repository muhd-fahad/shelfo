import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer/customer_model.dart';
import '../../provider/business_provider.dart';
import '../../provider/customer_provider.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_search_bar.dart';
import '../../widgets/sfo_common/sfo_button.dart';
import '../../widgets/sfo_common/sfo_chip.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import 'add_edit_customer_screen.dart';
import 'customer_details_screen.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        final businessProvider = context.read<BusinessProvider>();
        final currency = businessProvider.selectedCurrency;

        return Scaffold(
          appBar: AppBar(
            title: const SFOHeader(
              title: "Customers",
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xl),
                child: SFOButton(
                  text: "Add Customer",
                  icon: Icons.add,
                  width: 140,
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddEditCustomerScreen()),
                  ),
                ),
              ),
            ],
          ),
          body: SFOBackground(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: SFOSearchBar(
                    hintText: "Search Customers",
                    onChanged: (val) => provider.setSearchQuery(val),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: .start,
                    children: ["All", "Active", "Credit", "Overdue"].map((status) {
                      final isSelected = provider.filterStatus == status;
                      return Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: SFOChip(
                          label: status,
                          isSelected: isSelected,
                          onSelected: (val) => provider.setFilterStatus(status),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.customers.isEmpty
                          ? const Center(child: Text("No customers found"))
                          : ListView.separated(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              itemCount: provider.customers.length,
                              separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
                              itemBuilder: (context, index) {
                                final customer = provider.customers[index];
                                return _CustomerCard(
                                  customer: customer,
                                  currency: currency,
                                  outstanding: provider.getOutstanding(customer),
                                  progress: provider.getProgress(customer),
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CustomerDetailsScreen(customerId: customer.id),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final dynamic customer;
  final dynamic currency;
  final double outstanding;
  final double progress;
  final VoidCallback onTap;

  const _CustomerCard({
    required this.customer,
    required this.currency,
    required this.outstanding,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Text(
                    customer.name.substring(0, 2).toUpperCase(),
                    style: theme.textTheme.labelLarge?.copyWith(color: colorScheme.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${customer.type == CustomerType.business ? 'Business' : 'Individual'}  •  Last Sale: Oct 24, 2024",
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    CurrencyFormatter.format(outstanding, currency),
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Outstanding", style: theme.textTheme.labelSmall),
                    Text(
                      CurrencyFormatter.format(outstanding, currency),
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Credit Limit", style: theme.textTheme.labelSmall),
                    Text(
                      CurrencyFormatter.format(customer.creditLimit, currency),
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: colorScheme.surfaceContainer,
              color: AppColors.success,
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ],
        ),
      ),
    );
  }
}
