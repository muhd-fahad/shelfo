import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/vendor/vendor_model.dart';
import '../../provider/purchase/vendor_provider.dart';
import '../../screens/purchase/add_vendor_screen.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_search_bar.dart';

class VendorSelectionSheet extends StatelessWidget {
  const VendorSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final vendorProvider = context.watch<VendorProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: SFOSearchBar(
                  hintText: "Search vendor...",
                  onChanged: (val) => vendorProvider.setSearchQuery(val),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton.filled(
                onPressed: () async {
                  final newVendor = await Navigator.push<Vendor>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddVendorScreen(),
                    ),
                  );
                  if (newVendor != null && context.mounted) {
                    Navigator.pop(context, newVendor);
                  }
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400.h,
          child: vendorProvider.vendors.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No vendors found",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () async {
                          final newVendor = await Navigator.push<Vendor>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddVendorScreen(),
                            ),
                          );
                          if (newVendor != null && context.mounted) {
                            Navigator.pop(context, newVendor);
                          }
                        },
                        child: const Text("Create New Vendor"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: vendorProvider.vendors.length,
                  itemBuilder: (context, index) {
                    final vendor = vendorProvider.vendors[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Text(
                            vendor.companyName[0].toUpperCase(),
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          vendor.companyName,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          vendor.phone ?? vendor.email ?? "No contact info",
                          style: theme.textTheme.bodySmall,
                        ),
                        onTap: () {
                          Navigator.pop(context, vendor);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
