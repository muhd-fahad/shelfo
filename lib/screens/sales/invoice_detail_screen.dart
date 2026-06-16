import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/sale/sale_model.dart';
import '../../models/business/business_model.dart';
import '../../models/currency/currency.dart';
import '../../provider/business_provider.dart';
import '../../provider/customer_provider.dart';
import '../../provider/product_provider.dart';
import '../../provider/sale_provider.dart';
import '../../services/hive/business_service.dart';
import '../../utils/formatters/currency_formatter.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_badge.dart';
import '../../widgets/sfo_common/sfo_divider.dart';
import '../../widgets/sfo_common/sfo_price_row.dart';
import '../../services/pdf/pdf_service.dart';
import 'invoice_form_screen.dart';

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
          appBar: SFOHeader(
            title: "Invoice ${sale.id}",
            subtitle: "${dateFormat.format(sale.dateTime)} at ${timeFormat.format(sale.dateTime)}",
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvoiceFormScreen(invoice: sale),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                onPressed: () => _showDeleteDialog(context),
              ),
              SizedBox(width: 8.w),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSpacing.xl),
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
                      _buildInvoiceHeader(context, theme, business, isRefunded),
                      SizedBox(height: AppSpacing.xl),
                      const SFODivider(),
                      SizedBox(height: AppSpacing.md),
                      _buildItemsTable(theme, currency),
                      SizedBox(height: AppSpacing.md),
                      const SFODivider(),
                      SizedBox(height: AppSpacing.md),
                      _buildSummarySection(theme, currency, colorScheme),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                _buildActionRow(business, currency),
                SizedBox(height: AppSpacing.xl),
                if (!isRefunded) _buildRefundButton(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvoiceHeader(BuildContext context, ThemeData theme, Business? business, bool isRefunded) {
    return Row(
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
              SizedBox(height: 4.h),
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
            Builder(
              builder: (context) {
                final customer = context.watch<CustomerProvider>().customers
                    .where((c) => c.name == sale.customerName).firstOrNull;
                if (customer == null) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (customer.phone != null)
                      Text(customer.phone!, style: theme.textTheme.bodySmall),
                    if (customer.address != null)
                      Text(customer.address!, 
                        style: theme.textTheme.bodySmall, 
                        textAlign: TextAlign.right,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: 8.h),
            SFOBadge(
              label: sale.status,
              bgColor: isRefunded ? AppColors.error.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
              textColor: isRefunded ? AppColors.error : AppColors.success,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsTable(ThemeData theme, Currency currency) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Text("Item", style: theme.textTheme.labelMedium)),
            SizedBox(width: 34.w, child: Text("Qty", textAlign: TextAlign.center, style: theme.textTheme.labelMedium)),
            SizedBox(width: 72.w, child: Text("Price", textAlign: TextAlign.right, style: theme.textTheme.labelMedium)),
            SizedBox(width: 72.w, child: Text("Total", textAlign: TextAlign.right, style: theme.textTheme.labelMedium)),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        ...sale.items.map((item) => Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.productName, 
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: 34.w,
                    child: Text("${item.quantity}", textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
                  ),
                  SizedBox(
                    width: 72.w,
                    child: Text(CurrencyFormatter.format(item.price, currency), textAlign: TextAlign.right, style: theme.textTheme.bodyMedium),
                  ),
                  SizedBox(
                    width: 72.w,
                    child: Text(
                      CurrencyFormatter.format(item.total, currency), 
                      textAlign: TextAlign.right, 
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildSummarySection(ThemeData theme, Currency currency, ColorScheme colorScheme) {
    return Column(
      children: [
        SFOPriceRow(label: "Subtotal", value: CurrencyFormatter.format(sale.subtotal, currency)),
        SizedBox(height: AppSpacing.xs),
        SFOPriceRow(label: "Tax", value: CurrencyFormatter.format(sale.taxAmount, currency)),
        SizedBox(height: AppSpacing.md),
        const SFODivider(),
        SizedBox(height: AppSpacing.md),
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
        SizedBox(height: AppSpacing.md),
        Text(
          "Paid via ${sale.paymentMethod}",
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildActionRow(Business? business, Currency currency) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IconButton(
          icon: Icons.print_outlined,
          onTap: () => PdfService.generateAndPrintInvoice(sale, business, currency),
        ),
        SizedBox(width: AppSpacing.lg),
        _IconButton(
          icon: Icons.share_outlined,
          onTap: () => PdfService.generateAndShareInvoice(sale, business, currency),
        ),
        SizedBox(width: AppSpacing.lg),
        _IconButton(
          icon: Icons.download_outlined,
          onTap: () => PdfService.generateAndDownloadInvoice(sale, business, currency),
        ),
      ],
    );
  }

  Widget _buildRefundButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showRefundDialog(context);
      },
      child: const Text(
        "Issue Refund",
        style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Invoice"),
        content: const Text("Are you sure you want to delete this invoice? This action cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await context.read<SaleProvider>().deleteSale(
                sale,
                productProvider: context.read<ProductProvider>(),
              );
              if (context.mounted) {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // go back to list
              }
            },
            child: const Text("Delete", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  void _showRefundDialog(BuildContext context) {
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
        width: 56.r,
        height: 56.r,
        decoration: ShapeDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.white,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.md,
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Icon(icon, size: 24.r, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
