import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/currency/currency.dart';
import '../../models/customer/customer_model.dart';
import '../../provider/business_provider.dart';
import '../../provider/customer_provider.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_search_bar.dart';
import '../../widgets/sfo_common/sfo_chip.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import 'add_edit_customer_screen.dart';
import 'customer_details_screen.dart';

import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

class CustomerListScreen extends StatelessWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerProvider>(
      builder: (context, provider, child) {
        final businessProvider = context.read<BusinessProvider>();
        final currency = businessProvider.selectedCurrency;

        return Scaffold(
          appBar: const SFOHeader(
            title: "Customers",
          ),
          floatingActionButton: FloatingActionButton.extended(
            heroTag: null,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddEditCustomerScreen()),
            ),
            label: const Text("Add Customer"),
            icon: const Icon(Icons.add),
          ),
          body: SFOBackground(
            child: SFOResponsive(
              mobile: _buildContent(context, provider, currency, 1, AppSpacing.xl),
              tablet: _buildContent(context, provider, currency, 2, 32.w),
              desktop: _buildContent(context, provider, currency, 3, 32.w),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    CustomerProvider provider,
    Currency currency,
    int crossAxisCount,
    double horizontalPadding,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.md),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SFOSearchBar(
            hintText: "Search Customers",
            onChanged: (val) => provider.setSearchQuery(val),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            mainAxisAlignment: .start,
            children: ["All", "Active", "Credit", "Overdue"].map((status) {
              final isSelected = status == "All" ? provider.filterStatuses.isEmpty : provider.filterStatuses.contains(status);
              return Padding(
                padding: EdgeInsets.only(right: AppSpacing.sm),
                child: SFOChip(
                  label: status,
                  isSelected: isSelected,
                  onSelected: (val) => provider.toggleFilterStatus(status),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Expanded(
          child: provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.customers.isEmpty
                  ? const Center(child: Text("No customers found"))
                  : crossAxisCount > 1
                      ? GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisExtent: 180.h,
                          ),
                          itemCount: provider.customers.length,
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
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          itemCount: provider.customers.length,
                          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
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
        padding: EdgeInsets.all(AppSpacing.xl),
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
                SizedBox(width: AppSpacing.md),
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
            SizedBox(height: AppSpacing.lg),
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
            SizedBox(height: AppSpacing.sm),
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
