import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_button.dart';
import 'tabs/vendors_tab.dart';
import 'tabs/purchase_orders_tab.dart';
import 'add_vendor_screen.dart';
import 'new_purchase_order_screen.dart';

class PurchasingScreen extends StatelessWidget {
  const PurchasingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PurchasingTabProvider(),
      child: const _PurchasingContent(),
    );
  }
}

class PurchasingTabProvider extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  void setIndex(int i) {
    _index = i;
    notifyListeners();
  }
}

class _PurchasingContent extends StatelessWidget {
  const _PurchasingContent();

  @override
  Widget build(BuildContext context) {
    final tabProvider = context.watch<PurchasingTabProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: SFOHeader(
          title: "Purchasing",
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: SFOButton(
                text: tabProvider.index == 0 ? "Add Vendor" : "New PO",
                onPressed: () {
                  if (tabProvider.index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddVendorScreen()),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewPurchaseOrderScreen()),
                    );
                  }
                },
                icon: Icons.add,
                width: 130.w,
              ),
            ),
          ],
        ),
        body: SFOBackground(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: TabBar(
                  onTap: tabProvider.setIndex,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: "Vendors"),
                    Tab(text: "Purchase Orders"),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(), // Sync with TabProvider
                  children: [
                    VendorsTab(),
                    PurchaseOrdersTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
