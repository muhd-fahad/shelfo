import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/screens/inventory/inventory_screen.dart';
import 'package:shelfo/screens/customer/customer_list_screen.dart';
import '../../provider/business/navigation_provider.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/pos/pos_screen.dart';
import '../../screens/reports/report_screen.dart';
import '../../screens/sales/sales_history_screen.dart';
import '../../screens/sales/sales_order_screen.dart';
import 'package:shelfo/screens/settings/settings_screen.dart';
import 'package:shelfo/utils/theme/app_constants/breakpoints.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({super.key});

  final _pages = const [
    HomeScreen(),
    PosScreen(),
    SalesOrderScreen(),
    InventoryScreen(),
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
              onDestinationSelected: (index) {
                context.read<NavigationProvider>().setIndex(index);
              },
              labelType: isDesktop
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.home_rounded, size: 24.r),
                  label: const Text("Home"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.monitor_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.monitor_rounded, size: 24.r),
                  label: const Text("POS"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_cart_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.shopping_cart_rounded, size: 24.r),
                  label: const Text("Sales"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_cart_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.shopping_cart_rounded, size: 24.r),
                  label: const Text("Sales"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.inventory_2_rounded, size: 24.r),
                  label: const Text("Stock"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline_rounded, size: 24.r),
                  selectedIcon: Icon(Icons.people_rounded, size: 24.r),
                  label: const Text("Customers"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.bar_chart_rounded, size: 24.r),
                  label: const Text("Reports"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.history_rounded, size: 24.r),
                  label: const Text("History"),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.settings_rounded, size: 24.r),
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
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) {
                _setMobileIndex(context, index);
              },
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.home_rounded, size: 24.r),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.monitor_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.monitor_rounded, size: 24.r),
                  label: "POS",
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.shopping_cart_rounded, size: 24.r),
                  label: "Sales",
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined, size: 24.r),
                  selectedIcon: Icon(Icons.inventory_2_rounded, size: 24.r),
                  label: "Stock",
                ),
              ],
            )
          : null,
    );
  }

  int _getMobileIndex(int currentIndex) {
    if (currentIndex < 4) return currentIndex;
    if (currentIndex == 7) return 4;
    return 0; // Fallback or handle appropriately
  }

  void _setMobileIndex(BuildContext context, int index) {
    if (index < 4) {
      context.read<NavigationProvider>().setIndex(index);
    } else if (index == 4) {
      context.read<NavigationProvider>().setIndex(7);
    }
  }
}
