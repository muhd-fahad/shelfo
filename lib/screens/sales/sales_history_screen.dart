import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/currency/currency.dart';
import '../../models/sale/sale_model.dart';
import '../../provider/customer_provider.dart';
import '../../provider/sale_provider.dart';
import '../../provider/business_provider.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_search_bar.dart';
import '../../widgets/sfo_common/sfo_badge.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import 'invoice_detail_screen.dart';
import 'invoice_form_screen.dart';

import 'package:shelfo/utils/theme/app_constants/breakpoints.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saleProvider = context.watch<SaleProvider>();
    final businessProvider = context.read<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: const SFOHeader(
        title: "Sales History",
        subtitle: "Past transactions",
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const InvoiceFormScreen()),
          );
        },
        label: const Text("New Invoice"),
        icon: const Icon(Icons.add),
      ),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildContent(context, saleProvider, currency, 1, AppSpacing.xl),
          tablet: _buildContent(context, saleProvider, currency, 2, 32.w),
          desktop: _buildContent(context, saleProvider, currency, 3, 32.w),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SaleProvider saleProvider,
    Currency currency,
    int crossAxisCount,
    double horizontalPadding,
  ) {
    return Column(
      children: [
        SizedBox(height: AppSpacing.lg),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: SFOSearchBar(
            hintText: "Search invoice or customer...",
            onChanged: (val) => saleProvider.setSearchQuery(val),
          ),
        ),
        SizedBox(height: AppSpacing.lg),
        Expanded(
          child: saleProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : saleProvider.sales.isEmpty
                  ? const Center(child: Text("No transactions found"))
                  : crossAxisCount > 1
                      ? GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppSpacing.sm),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            mainAxisExtent: 140.h,
                          ),
                          itemCount: saleProvider.sales.length,
                          itemBuilder: (context, index) {
                            final sale = saleProvider.sales[index];
                            return _TransactionCard(
                              sale: sale,
                              currency: currency,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InvoiceDetailScreen(sale: sale),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: AppSpacing.sm),
                          itemCount: saleProvider.sales.length,
                          separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final sale = saleProvider.sales[index];
                            return _TransactionCard(
                              sale: sale,
                              currency: currency,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InvoiceDetailScreen(sale: sale),
                                  ),
                                );
                              },
                            );
                          },
                        ),
        ),
      ],
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Sale sale;
  final dynamic currency;
  final VoidCallback onTap;

  const _TransactionCard({
    required this.sale,
    required this.currency,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    final customerProvider = context.watch<CustomerProvider>();
    final customer = customerProvider.customers.where((c) => c.name == sale.customerName).firstOrNull;

    final dateFormat = DateFormat('MMM dd, yyyy');
    final isRefunded = sale.status == 'Refunded';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.lg,
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  sale.paymentMethod,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        sale.id,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      SFOBadge(
                        label: sale.status,
                        bgColor: isRefunded ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                        textColor: isRefunded ? AppColors.error : AppColors.success,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${dateFormat.format(sale.dateTime)}  •  ${sale.customerName}",
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (customer?.phone != null)
                    Text(
                      customer!.phone!,
                      style: theme.textTheme.labelSmall?.copyWith(fontSize: 10.sp),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(sale.total, currency),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.chevron_right, size: 20.r, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
