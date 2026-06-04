import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/vendor/vendor_model.dart';
import '../../../provider/vendor_provider.dart';
import '../../../provider/purchase_order_provider.dart';
import '../../../provider/business_provider.dart';
import '../../../utils/formatters/currency_formatter.dart';
import '../../../widgets/sfo_common/sfo_background.dart';
import '../../../widgets/sfo_common/sfo_header.dart';
import '../../../widgets/sfo_common/sfo_badge.dart';
import '../../../widgets/sfo_common/sfo_card.dart';
import 'add_vendor_screen.dart';
import 'purchase_order_details_screen.dart';

class VendorDetailsScreen extends StatelessWidget {
  final Vendor vendor;
  const VendorDetailsScreen({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;
    final poProvider = context.watch<PurchaseOrderProvider>();
    final vendorOrders = poProvider.orders.where((o) => o.vendorId == vendor.id).toList();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: SFOHeader(
        title: "Vendor Details",
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddVendorScreen(vendor: vendor)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              context.read<VendorProvider>().deleteVendor(vendor);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SFOBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
                    child: Text(
                      vendor.companyName.substring(0, 1).toUpperCase(),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vendor.companyName,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${vendor.contactPerson ?? ''}  •  ${vendor.category ?? 'General'}",
                          style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
                        ),
                        if (vendor.dueAmount > 0) ...[
                          SizedBox(height: 8.h),
                          SFOBadge(
                            label: "Due: ${CurrencyFormatter.format(vendor.dueAmount, currency)}",
                            bgColor: Colors.red.withOpacity(0.1),
                            textColor: Colors.red,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              SFOCard(
                padding: EdgeInsets.all(16.r),
                children: [
                  _buildDetailRow("Email", vendor.email ?? "N/A"),
                  const Divider(),
                  _buildDetailRow("Phone", vendor.phone ?? "N/A"),
                  const Divider(),
                  _buildDetailRow("Address", vendor.address ?? "N/A"),
                  const Divider(),
                  _buildDetailRow(
                    "Last Order",
                    vendorOrders.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(vendorOrders.first.date)
                        : "No orders yet",
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Text(
                "Purchase Orders (${vendorOrders.length})",
                style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey),
              ),
              SizedBox(height: 12.h),
              ...vendorOrders.map((order) => Padding(
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.id,
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('MMM dd, yyyy').format(order.date),
                                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    CurrencyFormatter.format(order.total, currency),
                                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SFOBadge(
                                    label: order.status.name[0].toUpperCase() + order.status.name.substring(1),
                                    bgColor: theme.colorScheme.surfaceVariant,
                                    textColor: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
