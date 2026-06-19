import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/purchase/purchase_order_model.dart';
import '../../../models/currency/currency.dart';
import '../../../provider/business/business_provider.dart';
import '../../../provider/purchase/purchase_order_provider.dart';
import '../../../utils/formatters/currency_formatter.dart';
import '../../../widgets/sfo_common/sfo_search_bar.dart';
import '../../../widgets/sfo_common/sfo_card.dart';
import '../../../widgets/sfo_common/sfo_badge.dart';
import '../../../widgets/sfo_common/sfo_chip.dart';
import '../../../utils/theme/theme.dart';
import '../purchase_order_details_screen.dart';

class PurchaseOrdersTab extends StatelessWidget {
  const PurchaseOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<PurchaseOrderProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: SFOSearchBar(
            onChanged: orderProvider.setSearchQuery,
            hintText: "Search POs...",
          ),
        ),
        SizedBox(
          height: 36.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            children: [
              SFOChip(
                label: "All",
                isSelected: orderProvider.statusFilter == null,
                onSelected: (_) => orderProvider.setStatusFilter(null),
              ),
              ...PurchaseOrderStatus.values.map((status) => Padding(
                padding: EdgeInsets.only(left: 8.w),
                child: SFOChip(
                  label: status.name[0].toUpperCase() + status.name.substring(1),
                  isSelected: orderProvider.statusFilter == status,
                  onSelected: (_) => orderProvider.setStatusFilter(status),
                ),
              )),
            ],
          ),
        ),
        Expanded(
          child: orderProvider.orders.isEmpty
              ? const Center(child: Text("No purchase orders found"))
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: orderProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderProvider.orders[index];
                    return _POCard(order: order, currency: currency);
                  },
                ),
        ),
      ],
    );
  }
}

class _POCard extends StatelessWidget {
  final PurchaseOrder order;
  final Currency currency;

  const _POCard({required this.order, required this.currency});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PurchaseOrderDetailsScreen(order: order),
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
                        order.vendorName,
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${order.id}  •  ${DateFormat('MMM dd, yyyy').format(order.date)}",
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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

  Widget _buildStatusBadge(PurchaseOrderStatus status) {
    Color color;
    switch (status) {
      case PurchaseOrderStatus.received:
        color = AppColors.success;
        break;
      case PurchaseOrderStatus.ordered:
        color = Colors.blue;
        break;
      case PurchaseOrderStatus.partial:
        color = Colors.orange;
        break;
      case PurchaseOrderStatus.cancelled:
        color = AppColors.error;
        break;
      case PurchaseOrderStatus.draft:
        color = Colors.grey;
        break;
    }

    return SFOBadge(
      label: status.name[0].toUpperCase() + status.name.substring(1),
      bgColor: color.withValues(alpha:0.1),
      textColor: color,
    );
  }
}
