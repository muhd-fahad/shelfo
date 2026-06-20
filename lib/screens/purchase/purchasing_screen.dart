import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';
import '../../widgets/sfo_common/sfo_header.dart';
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
        appBar: const SFOHeader(
          title: "Purchasing",
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: null,
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
          label: Text(tabProvider.index == 0 ? "Add Vendor" : "New PO"),
          icon: const Icon(Icons.add),
        ),
        body: SFOBackground(
          child: SFOResponsive(
            mobile: _buildContent(context, tabProvider, false),
            desktop: _buildContent(context, tabProvider, true),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PurchasingTabProvider tabProvider, bool isDesktop) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: isDesktop ? 32.w : 16.w, vertical: 8.h),
          constraints: isDesktop ? const BoxConstraints(maxWidth: 600) : null,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: TabBar(
            onTap: tabProvider.setIndex,
            indicator: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            labelColor: colorScheme.primary,
            unselectedLabelColor: colorScheme.onSurfaceVariant,
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
    );
  }
}
