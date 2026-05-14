import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/sale/sale_model.dart';
import '../../provider/sale_provider.dart';
import '../../provider/business_provider.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_search_bar.dart';
import '../../widgets/sfo_common/sfo_button.dart';
import '../../widgets/sfo_common/sfo_badge.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import 'invoice_detail_screen.dart';

class SalesHistoryScreen extends StatelessWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final saleProvider = context.watch<SaleProvider>();
    final businessProvider = context.read<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(
          title: "Sales History",
          subtitle: "Past transactions",
        ),
      ),
      body: SFOBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                children: [
                  Expanded(
                    child: SFOButton(
                      text: "Date",
                      icon: Icons.calendar_today_outlined,
                      backgroundColor: theme.colorScheme.surface,
                      onPressed: () {
                        // Date filter logic
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SFOButton(
                      text: "Export",
                      icon: Icons.file_download_outlined,
                      backgroundColor: theme.colorScheme.surface,
                      onPressed: () {
                        // Export all sales logic
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: SFOSearchBar(
                hintText: "Search invoice or customer...",
                onChanged: (val) => saleProvider.setSearchQuery(val),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: saleProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : saleProvider.sales.isEmpty
                  ? const Center(child: Text("No transactions found"))
                  : ListView.separated(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                itemCount: saleProvider.sales.length,
                separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.md),
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
        ),
      ),
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

    final dateFormat = DateFormat('MMM dd, yyyy');
    final isRefunded = sale.status == 'Refunded';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  sale.paymentMethod,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
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
                      const SizedBox(width: AppSpacing.sm),
                      SFOBadge(
                        label: sale.status,
                        bgColor: isRefunded ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                        textColor: isRefunded ? AppColors.error : AppColors.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${dateFormat.format(sale.dateTime)}  •  ${sale.customerName}",
                    style: theme.textTheme.bodySmall,
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
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
