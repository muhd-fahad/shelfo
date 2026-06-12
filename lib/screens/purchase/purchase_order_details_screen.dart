import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/purchase/purchase_order_model.dart';
import '../../../provider/purchase_order_provider.dart';
import '../../../provider/business_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../utils/formatters/currency_formatter.dart';
import '../../../widgets/sfo_common/sfo_background.dart';
import '../../../widgets/sfo_common/sfo_header.dart';
import '../../../widgets/sfo_common/sfo_badge.dart';
import '../../../widgets/sfo_common/sfo_button.dart';
import '../../../widgets/sfo_common/sfo_card.dart';
import '../../../utils/theme/theme.dart';
import 'new_purchase_order_screen.dart';

class PurchaseOrderDetailsScreen extends StatelessWidget {
  final PurchaseOrder order;
  const PurchaseOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;
    final orderProvider = context.watch<PurchaseOrderProvider>();
    final theme = Theme.of(context);

    // Find the latest version of this order from provider
    final currentOrder = orderProvider.orders.firstWhere(
      (o) => o.id == order.id,
      orElse: () => order,
    );

    return Scaffold(
      appBar: SFOHeader(
        title: "PO Details",
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewPurchaseOrderScreen(
                    order: currentOrder,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              orderProvider.deleteOrder(
                currentOrder,
                productProvider: context.read<ProductProvider>(),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SFOBackground(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Purchase Order",
                                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                                  ),
                                  Text(
                                    currentOrder.id,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              _buildStatusBadge(currentOrder.status),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            currentOrder.vendorName,
                            style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              _buildInfoItem("Ordered:", DateFormat('MMM dd, yyyy').format(currentOrder.date)),
                              SizedBox(width: 24.w),
                              _buildInfoItem(
                                "Expected:",
                                currentOrder.expectedDate != null
                                    ? DateFormat('MMM dd, yyyy').format(currentOrder.expectedDate!)
                                    : "N/A",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Items ( ${currentOrder.items.length} )",
                      style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
                    ),
                    SizedBox(height: 12.h),
                    SFOCard(
                      padding: EdgeInsets.all(16.r),
                      children: [
                        ...currentOrder.items.map((item) => Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48.r,
                                    height: 48.r,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.productName,
                                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${item.quantity}  ×  ₹ ${item.costPrice}${currentOrder.status == PurchaseOrderStatus.received ? '  •  Received: ${item.quantity}' : ''}",
                                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    CurrencyFormatter.format(item.total, currency),
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            )),
                        const Divider(),
                        Padding(
                          padding: EdgeInsets.only(top: 8.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                CurrencyFormatter.format(currentOrder.total, currency),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (currentOrder.notes != null && currentOrder.notes!.isNotEmpty) ...[
                      SizedBox(height: 24.h),
                      Text(
                        currentOrder.notes!,
                        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (currentOrder.status != PurchaseOrderStatus.received && currentOrder.status != PurchaseOrderStatus.cancelled)
              Padding(
                padding: EdgeInsets.all(16.r),
                child: SFOButton(
                  text: currentOrder.status == PurchaseOrderStatus.ordered
                      ? "Mark Received (Updates Stock)"
                      : "Send Order",
                  onPressed: () {
                    final newStatus = currentOrder.status == PurchaseOrderStatus.ordered
                        ? PurchaseOrderStatus.received
                        : PurchaseOrderStatus.ordered;
                    orderProvider.updateOrderStatus(
                          currentOrder,
                          newStatus,
                          productProvider: context.read<ProductProvider>(),
                        );
                  },
                  width: double.infinity,
                  icon: Icons.check_circle_outline,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 10.sp)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w500)),
      ],
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
      bgColor: color.withValues(alpha: 0.1),
      textColor: color,
    );
  }
}
