import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/screens/inventory/inventory_screen.dart';
import '../../provider/navigation_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/pos/pos_screen.dart';
import '../../screens/sales_order_screen.dart';
import 'package:shelfo/screens/settings/settings_screen.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({super.key});

  final _pages = const [
    HomeScreen(),
    PosScreen(),
    SalesOrderScreen(),
    InventoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: navProvider.currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          context.read<NavigationProvider>().setIndex(index);
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
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, size: 24.r),
            selectedIcon: Icon(Icons.settings_rounded, size: 24.r),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
