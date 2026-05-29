import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/models/sale/sales_order_model.dart';
import 'package:shelfo/provider/sales_order_provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_badge.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_chip.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';

import '../../provider/customer_provider.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sales/sales_order_filter_sheet.dart';
import 'new_order_screen.dart';
import 'sales_order_detail_screen.dart';

class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<SalesOrderProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader( title: "Sales Orders"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SFOButton(
              text: "New Order",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewOrderScreen()),
                );
              },
              icon: Icons.add,
              width: 120.w,
            ),
          ),
        ],
      ),
      body: SFOBackground(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: SFOSearchBar(
                onChanged: orderProvider.setSearchQuery,
                hintText: "Search orders...",
                onFilterTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (context) => const SalesOrderFilterSheet(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 36.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: SalesOrderStatus.values.length,
                separatorBuilder: (_, _) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final status = SalesOrderStatus.values[index];
                  final isSelected = orderProvider.statusFilter == status;
                  return SFOChip(
                    label: status.name[0].toUpperCase() + status.name.substring(1),
                    isSelected: isSelected,
                    onSelected: (_) => orderProvider.setStatusFilter(status),
                  );
                },
              ),
            ),
            Expanded(
              child: orderProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : orderProvider.orders.isEmpty
                      ? const Center(child: Text("No orders found"))
                      : ListView.builder(
                          padding: EdgeInsets.all(16.w),
                          itemCount: orderProvider.orders.length,
                          itemBuilder: (context, index) {
                            final order = orderProvider.orders[index];
                            return _OrderCard(order: order, currency: currency);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final SalesOrder order;
  final Currency currency;

  const _OrderCard({required this.order, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customerProvider = context.watch<CustomerProvider>();
    final customer = customerProvider.customers.where((c) => c.name == order.customerName).firstOrNull;
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SalesOrderDetailScreen(order: order),
            ),
          );
        },
        child: SFOCard(
          padding: EdgeInsets.all(16.r),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (customer?.phone != null) ...[
                        Text(
                          customer!.phone!,
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                        SizedBox(height: 4.h),
                      ],
                      Text(
                        "${order.id} • ${DateFormat('MMM dd, yyyy').format(order.date)}",
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${order.items.length} item${order.items.length > 1 ? 's' : ''}",
                  style: theme.textTheme.bodySmall,
                ),
                Text(
                  CurrencyFormatter.format(order.total, currency),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
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
      bgColor: color.withOpacity(0.1),
      textColor: color,
    );
  }
}
