import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/models/sale/sales_order_model.dart';
import 'package:shelfo/models/sale/sale_model.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import '../../provider/business/business_provider.dart';
import '../../provider/business/tax_provider.dart';
import '../../provider/customer/customer_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../provider/sales/sale_provider.dart';
import '../../provider/sales/sales_order_provider.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import 'new_order_screen.dart';

class SalesOrderDetailScreen extends StatelessWidget {
  final SalesOrder order;

  const SalesOrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;
    final orderProvider = context.watch<SalesOrderProvider>();
    final taxProvider = context.watch<TaxProvider>();
    
    // Find the latest version of this order from provider
    final currentOrder = orderProvider.orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    );

    return Scaffold(
      appBar: SFOHeader(
        title: "Order ${order.id}",
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewOrderScreen(order: currentOrder),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              orderProvider.deleteOrder(
                currentOrder,
                productProvider: context.read<ProductProvider>(),
              );
              Navigator.pop(context);
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SFOBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildHeader(context, currentOrder),
              SizedBox(height: 16.h),
              _buildCustomerInfo(context, currentOrder),
              SizedBox(height: 16.h),
              _buildItemsList(context, currentOrder, currency, taxProvider.taxLabelController.text),
              SizedBox(height: 32.h),
              if (currentOrder.status != SalesOrderStatus.fulfilled && currentOrder.status != SalesOrderStatus.cancelled) ...[
                SFOButton(
                  text: "Mark Fulfilled",
                  icon: Icons.check_circle_outline,
                  onPressed: () async {
                    final saleProvider = context.read<SaleProvider>();
                    final productProvider = context.read<ProductProvider>();
                    final invoiceId = await saleProvider.getNextInvoiceId();
                    
                    // Create Invoice from Sales Order
                    final newSale = Sale(
                      id: invoiceId,
                      dateTime: DateTime.now(),
                      customerName: currentOrder.customerName,
                      items: currentOrder.items,
                      subtotal: currentOrder.subtotal,
                      taxAmount: currentOrder.taxAmount,
                      total: currentOrder.total,
                      paymentMethod: "Cash", // Default
                      status: "Paid",
                      notes: "Created from Sales Order ${currentOrder.id}",
                    );
                    
                    // Since stock was likely reduced when the Sales Order was created (if it was Pending),
                    // we don't pass productProvider here to avoid double-reducing.
                    // HOWEVER, if the Sales Order was 'Draft', it didn't reduce stock yet.
                    bool alreadyReduced = currentOrder.status != SalesOrderStatus.draft;
                    
                    await saleProvider.addSale(newSale, productProvider: alreadyReduced ? null : productProvider);
                    await orderProvider.updateOrderStatus(currentOrder, SalesOrderStatus.fulfilled, productProvider: productProvider);
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Order fulfilled and Invoice $invoiceId created")),
                      );
                    }
                  },
                  backgroundColor: AppColors.success,
                ),
                SizedBox(height: 12.h),
                SFOButton(
                  text: "Cancel Order",
                  icon: Icons.cancel_outlined,
                  type: SFOButtonType.outlined,
                  onPressed: () {
                    orderProvider.updateOrderStatus(
                      currentOrder, 
                      SalesOrderStatus.cancelled,
                      productProvider: context.read<ProductProvider>(),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, SalesOrder order) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: ShapeDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFF1A1F2B),
        shape: RoundedSuperellipseBorder(borderRadius: AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order Number",
                style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
              ),
              _buildStatusBadge(order.status),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            order.id,
            style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.white70),
              SizedBox(width: 8.w),
              Text(
                DateFormat('MMM z, yyyy').format(order.date),
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
              SizedBox(width: 24.w),
              Icon(Icons.access_time, size: 16, color: order.isPaid ? AppColors.success : Colors.white70),
              SizedBox(width: 8.w),
              Text(
                order.isPaid ? "Paid" : "Unpaid",
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(BuildContext context, SalesOrder order) {
    final theme = Theme.of(context);
    final customerProvider = context.read<CustomerProvider>();
    
    // Try to find full customer details
    final customer = customerProvider.customers.where((c) => c.name == order.customerName).firstOrNull;

    return SFOCard(
      padding: EdgeInsets.all(16.r),
      children: [
        Text("Customer", style: theme.textTheme.labelSmall),
        SizedBox(height: 12.h),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha:0.1),
              child: Text(order.customerName[0], style: const TextStyle(color: AppColors.primary)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.customerName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  if (customer != null) ...[
                    Text("${customer.phone ?? 'No Phone'} • ${customer.address ?? 'No Address'}", style: theme.textTheme.bodySmall),
                  ],
                  if (order.notes != null)
                    Text(order.notes!, style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemsList(BuildContext context, SalesOrder order, Currency currency, String taxLabel) {
    final theme = Theme.of(context);
    return SFOCard(
      padding: EdgeInsets.all(16.r),
      children: [
        Text("Items ( ${order.items.length} )", style: theme.textTheme.labelSmall),
        SizedBox(height: 12.h),
        ...order.items.map((item) => Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.headphones, size: 20.r, color: theme.colorScheme.onSurfaceVariant),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.productName, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Text("${item.quantity} x ${CurrencyFormatter.format(item.price, currency)}", style: theme.textTheme.labelSmall),
                  ],
                ),
              ),
              Text(CurrencyFormatter.format(item.total, currency), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        )),
        if (order.items.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(child: Text("No items added", style: theme.textTheme.bodySmall)),
          ),
        const Divider(),
        SizedBox(height: 8.h),
        _buildPriceRow("Subtotal", order.subtotal, currency, theme),
        _buildPriceRow(taxLabel, order.taxAmount, currency, theme),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Total", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text(
              CurrencyFormatter.format(order.total, currency),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.success),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double amount, Currency currency, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(CurrencyFormatter.format(amount, currency), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(SalesOrderStatus status) {
    Color color;
    switch (status) {
      case SalesOrderStatus.fulfilled:
        color = AppColors.success;
        break;
      case SalesOrderStatus.pending:
        color = Colors.orange;
        break;
      case SalesOrderStatus.inTransit:
        color = Colors.blue;
        break;
      case SalesOrderStatus.cancelled:
        color = AppColors.error;
        break;
      case SalesOrderStatus.draft:
        color = Colors.orange.shade300;
        break;
      default:
        color = AppColors.textSecondary;
    }

    return SFOBadge(
      label: status.name[0].toUpperCase() + status.name.substring(1),
      bgColor: color.withValues(alpha:0.1),
      textColor: color,
    );
  }
}
