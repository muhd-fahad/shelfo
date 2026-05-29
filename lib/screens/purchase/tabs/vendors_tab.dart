import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../provider/vendor_provider.dart';
import '../../../provider/business_provider.dart';
import '../../../models/vendor/vendor_model.dart';
import '../../../models/currency/currency.dart';
import '../../../utils/formatters/currency_formatter.dart';
import '../../../widgets/sfo_common/sfo_search_bar.dart';
import '../../../widgets/sfo_common/sfo_card.dart';
import '../../../widgets/sfo_common/sfo_badge.dart';
import '../vendor_details_screen.dart';

class VendorsTab extends StatelessWidget {
  const VendorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vendorProvider = context.watch<VendorProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: SFOSearchBar(
            onChanged: vendorProvider.setSearchQuery,
            hintText: "Search vendors...",
          ),
        ),
        Expanded(
          child: vendorProvider.vendors.isEmpty
              ? const Center(child: Text("No vendors found"))
              : ListView.builder(
                  padding: EdgeInsets.all(16.w),
                  itemCount: vendorProvider.vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendorProvider.vendors[index];
                    return _VendorCard(vendor: vendor, currency: currency);
                  },
                ),
        ),
      ],
    );
  }
}

class _VendorCard extends StatelessWidget {
  final Vendor vendor;
  final Currency currency;

  const _VendorCard({required this.vendor, required this.currency});

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
              builder: (context) => VendorDetailsScreen(vendor: vendor),
            ),
          );
        },
        child: SFOCard(
          padding: EdgeInsets.all(16.r),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    vendor.companyName.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              vendor.companyName,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (vendor.dueAmount > 0)
                            SFOBadge(
                              label: "Due: ${CurrencyFormatter.format(vendor.dueAmount, currency)}",
                              bgColor: Colors.red.withOpacity(0.1),
                              textColor: Colors.red,
                            ),
                        ],
                      ),
                      Text(
                        "${vendor.contactPerson ?? ''} • ${vendor.category ?? 'General'}",
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.phone_outlined, size: 14.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(
                            vendor.phone ?? 'No phone',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                          SizedBox(width: 12.w),
                          Icon(Icons.calendar_today_outlined, size: 14.sp, color: Colors.grey),
                          SizedBox(width: 4.w),
                          Text(
                            DateFormat('MMM dd, yyyy').format(vendor.createdAt),
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
