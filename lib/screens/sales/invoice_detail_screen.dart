import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/sale/sale_model.dart';
import '../../provider/business_provider.dart';
import '../../provider/sale_provider.dart';
import '../../services/hive/business_service.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_badge.dart';
import '../../widgets/sfo_common/sfo_divider.dart';
import '../../widgets/sfo_common/sfo_price_row.dart';
import '../../services/pdf/pdf_service.dart';

class InvoiceDetailScreen extends StatelessWidget {
  final Sale sale;

  const InvoiceDetailScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: BusinessHiveService.getBusiness(),
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDark = theme.brightness == Brightness.dark;
        final businessProvider = context.watch<BusinessProvider>();
        final business = snapshot.data;
        final currency = businessProvider.selectedCurrency;

        final dateFormat = DateFormat('MMM dd, yyyy');
        final timeFormat = DateFormat('hh:mm a');
        final isRefunded = sale.status == 'Refunded';

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            title: SFOHeader(
              title: "Invoice ${sale.id}",
              subtitle: "${dateFormat.format(sale.dateTime)} at ${timeFormat.format(sale.dateTime)}",
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: ShapeDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.white,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: AppRadius.lg,
                      side: BorderSide(color: colorScheme.outlineVariant),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  business?.name ?? "Business Name",
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  business?.address ?? "Address not set",
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Billed to",
                                style: theme.textTheme.labelSmall,
                              ),
                              Text(
                                sale.customerName,
                                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              SFOBadge(
                                label: sale.status,
                                bgColor: isRefunded ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                                textColor: isRefunded ? AppColors.error : AppColors.success,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      const SFODivider(),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(child: Text("Item", style: theme.textTheme.labelMedium)),
                          Text("Qty", style: theme.textTheme.labelMedium),
                          const SizedBox(width: AppSpacing.lg),
                          Text("Price", style: theme.textTheme.labelMedium),
                          const SizedBox(width: AppSpacing.lg),
                          Text("Total", style: theme.textTheme.labelMedium),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      ...sale.items.map((item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                            child: Row(
                              children: [
                                Expanded(child: Text(item.productName, style: theme.textTheme.bodyMedium)),
                                Text("${item.quantity}", style: theme.textTheme.bodyMedium),
                                const SizedBox(width: AppSpacing.lg),
                                Text(CurrencyFormatter.format(item.price, currency), style: theme.textTheme.bodyMedium),
                                const SizedBox(width: AppSpacing.lg),
                                Text(CurrencyFormatter.format(item.total, currency), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )),
                      const SizedBox(height: AppSpacing.md),
                      const SFODivider(),
                      const SizedBox(height: AppSpacing.md),
                      SFOPriceRow(label: "Subtotal", value: CurrencyFormatter.format(sale.subtotal, currency)),
                      const SizedBox(height: AppSpacing.xs),
                      SFOPriceRow(label: "Tax", value: CurrencyFormatter.format(sale.taxAmount, currency)),
                      const SizedBox(height: AppSpacing.md),
                      const SFODivider(),
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Total", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                          Text(
                            CurrencyFormatter.format(sale.total, currency),
                            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        "Paid via ${sale.paymentMethod}",
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _IconButton(
                      icon: Icons.print_outlined,
                      onTap: () => PdfService.generateAndPrintInvoice(sale, business, currency),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _IconButton(
                      icon: Icons.share_outlined,
                      onTap: () => PdfService.generateAndShareInvoice(sale, business, currency),
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    _IconButton(
                      icon: Icons.download_outlined,
                      onTap: () => PdfService.generateAndDownloadInvoice(sale, business, currency),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                if (!isRefunded)
                  TextButton(
                    onPressed: () {
                      // Show refund confirmation
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Issue Refund"),
                          content: const Text("Are you sure you want to refund this sale? This will mark the sale as Refunded."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await context.read<SaleProvider>().updateSaleStatus(sale, 'Refunded');
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Sale marked as Refunded")),
                                  );
                                }
                              },
                              child: const Text("Confirm", style: TextStyle(color: AppColors.error)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text(
                      "Issue Refund",
                      style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
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

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.md,
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Icon(icon, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
