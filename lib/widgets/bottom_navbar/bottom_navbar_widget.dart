import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/screens/inventory_screen.dart';
import 'package:shelfo/screens/pos_screen.dart';
import 'package:shelfo/screens/settings/settings_screen.dart';
import '../../provider/navigation_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/sales_order_screen.dart';

class BottomNavbarWidget extends StatelessWidget {
  const BottomNavbarWidget({super.key});

  final _pages = const [HomeScreen(),PosScreen(),SalesOrderScreen(), InventoryScreen(), SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    return Scaffold(
      body: IndexedStack(index: navProvider.currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        // selected item
        currentIndex: navProvider.currentIndex,
        onTap: (index) {
          context.read<NavigationProvider>().setIndex(index);
        },

        // Styling
        selectedItemColor: Colors.green.shade700,
        unselectedItemColor: const Color(0xff94A3B8), // unselected
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,

        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor_outlined),
            activeIcon: Icon(Icons.monitor_rounded),
            label: "POS",
          ), BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart_rounded),
            label: "Sales",
          ), BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2_rounded),
            label: "Stock",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings_rounded),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
