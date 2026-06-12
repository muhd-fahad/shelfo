import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/customer/customer_model.dart';
import '../../provider/customer_provider.dart';
import '../../screens/customer/add_edit_customer_screen.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_search_bar.dart';

class CustomerSelectionSheet extends StatelessWidget {
  const CustomerSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customerProvider = context.watch<CustomerProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: SFOSearchBar(
                  hintText: "Search customer...",
                  onChanged: (val) => customerProvider.setSearchQuery(val),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton.filled(
                onPressed: () async {
                  final newCustomer = await Navigator.push<Customer>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddEditCustomerScreen(),
                    ),
                  );
                  if (newCustomer != null && context.mounted) {
                    Navigator.pop(context, newCustomer);
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
          child: customerProvider.customers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No customers found",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () async {
                          final newCustomer = await Navigator.push<Customer>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddEditCustomerScreen(),
                            ),
                          );
                          if (newCustomer != null && context.mounted) {
                            Navigator.pop(context, newCustomer);
                          }
                        },
                        child: const Text("Create New Customer"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: customerProvider.customers.length,
                  itemBuilder: (context, index) {
                    final customer = customerProvider.customers[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha:0.1),
                        child: Text(
                          customer.name[0],
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        customer.name,
                        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        customer.phone ?? customer.email ?? "No contact info",
                        style: theme.textTheme.bodySmall,
                      ),
                      trailing: Text(
                        customer.type == CustomerType.business ? "Business" : "Individual",
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                      ),
                      onTap: () {
                        Navigator.pop(context, customer);
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
