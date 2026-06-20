import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/screens/inventory/inventory_screen.dart';
import 'package:shelfo/screens/customer/customer_list_screen.dart';
import 'package:shelfo/screens/purchase/purchasing_screen.dart';
import '../../provider/business/navigation_provider.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/reports/report_screen.dart';
import '../../screens/sales/sales_history_screen.dart';
import '../../screens/sales/sales_order_screen.dart';
import '../../screens/service_job/job_ticket_screen.dart';
import 'package:shelfo/screens/settings/settings_screen.dart';
import 'package:shelfo/utils/theme/app_constants/breakpoints.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({super.key});

  final _pages = const [
    HomeScreen(),
    PurchasingScreen(),
    InventoryScreen(),
    JobTicketScreen(),
    SalesOrderScreen(),
    CustomerListScreen(),
    ReportScreen(),
    SalesHistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final width = MediaQuery.of(context).size.width;
    final bool isDesktop = width >= AppBreakpoints.desktop;
    final bool isTablet = width >= AppBreakpoints.tablet;
    final bool showRail = isTablet || isDesktop;

    return Scaffold(
      body: Row(
        children: [
          if (showRail)
            NavigationRail(
              extended: isDesktop,
              selectedIndex: navProvider.currentIndex,
              leading: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: SFOLogo(
                  height: 32.h,
                  isIconOnly: !isDesktop,
                ),
              ),
              onDestinationSelected: (index) {
                context.read<NavigationProvider>().setIndex(index);
              },
              labelType: isDesktop
                  ? NavigationRailLabelType.none
                  : null, // Uses theme default
              destinations: [
                NavigationRailDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: const Text("Home"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.local_shipping_outlined),
                  selectedIcon: const Icon(Icons.local_shipping_rounded),
                  label: const Text("Purchase"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.inventory_2_outlined),
                  selectedIcon: const Icon(Icons.inventory_2_rounded),
                  label: const Text("Stock"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.miscellaneous_services_outlined),
                  selectedIcon: const Icon(Icons.miscellaneous_services_rounded),
                  label: const Text("Service"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.shopping_cart_outlined),
                  selectedIcon: const Icon(Icons.shopping_cart_rounded),
                  label: const Text("Sales"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.people_outline_rounded),
                  selectedIcon: const Icon(Icons.people_rounded),
                  label: const Text("Customers"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.bar_chart_outlined),
                  selectedIcon: const Icon(Icons.bar_chart_rounded),
                  label: const Text("Reports"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.history_outlined),
                  selectedIcon: const Icon(Icons.history_rounded),
                  label: const Text("History"),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.settings_outlined),
                  selectedIcon: const Icon(Icons.settings_rounded),
                  label: const Text("Settings"),
                ),
              ],
            ),
          if (showRail) const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: navProvider.currentIndex,
              children: _pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: !showRail
          ? NavigationBar(
              selectedIndex: _getMobileIndex(navProvider.currentIndex),
              onDestinationSelected: (index) {
                _setMobileIndex(context, index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home_rounded),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.local_shipping_outlined),
                  selectedIcon: Icon(Icons.local_shipping_rounded),
                  label: "Purchase",
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2_rounded),
                  label: "Stock",
                ),
                NavigationDestination(
                  icon: Icon(Icons.handyman_outlined),
                  selectedIcon: Icon(Icons.handyman_rounded),
                  label: "Service",
                ),
              ],
            )
          : null,
    );
  }

  int _getMobileIndex(int currentIndex) {
    if (currentIndex >= 0 && currentIndex < 4) return currentIndex;
    return 0; // Default to first tab if the current index isn't in the mobile navbar
  }

  void _setMobileIndex(BuildContext context, int index) {
    // Mobile navbar only has 4 items (0-3)
    if (index >= 0 && index < 4) {
      context.read<NavigationProvider>().setIndex(index);
    }
  }
}
