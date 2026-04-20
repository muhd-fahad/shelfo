import 'package:flutter/material.dart';
import 'package:shelfo/screens/notification_screen.dart';
import 'package:shelfo/screens/onboard/business_info_screen.dart';
import 'package:shelfo/screens/onboard/invoice_settings_screen.dart';
import 'package:shelfo/screens/onboard/tax_config_screen.dart';
import 'package:shelfo/screens/purchase_order_screen.dart';
import 'package:shelfo/screens/sales_order_screen.dart';
import 'package:shelfo/screens/settings/business_details_screen.dart';
import 'package:shelfo/screens/settings/categories_settings_screen.dart';
import 'package:shelfo/screens/settings/invoice_settings_detail_screen.dart';
import 'package:shelfo/screens/settings/tax_settings_screen.dart';
import 'package:shelfo/widgets/bottom_navbar/bottom_navbar_widget.dart';

import '../screens/home_screen.dart';
import '../screens/inventory_screen.dart';
import '../screens/report_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';

  // initial data screens
  static const String businessInfo = '/businessInfo';
  static const String taxConfig = '/taxConfig';
  static const String invoiceSettings = '/invoice';
  static const String taxSettings = '/taxSettings';
  static const String invoiceDetails = '/invoiceDetails';

  static const String notification = '/notification';
  static const String inventory = '/category';
  static const String settings = '/settings';
  static const String businessDetails = '/businessDetails';
  static const String categoriesSettings = '/categoriesSettings';
  static const String pos = '/pos';
  static const String reports = '/reports';
  static const String salesOrder = '/salesOrder';
  static const String purchaseOrder = '/purchaseOrder';
  static const String bottomNavbar = '/bottomNavbar';

  static final Map<String, Widget Function(BuildContext)> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    businessInfo: (context) => const BusinessInfoScreen(),
    taxConfig: (context) => const TaxConfigScreen(),
    invoiceSettings: (context) => const InvoiceSettingsScreen(),
    notification: (context) => const NotificationScreen(),
    inventory: (context) => const InventoryScreen(),
    settings: (context) => const SettingsScreen(),
    businessDetails: (context) => const BusinessDetailsScreen(),
    categoriesSettings: (context) => const CategoriesSettingsScreen(),
    taxSettings: (context) => const TaxSettingsScreen(),
    invoiceDetails: (context) => const InvoiceSettingsDetailScreen(),
    pos: (context) => const HomeScreen(),
    reports: (context) => const ReportScreen(),
    salesOrder: (context) => const SalesOrderScreen(),
    purchaseOrder: (context) => const PurchaseOrderScreen(),
    bottomNavbar: (context) => const BottomNavbarWidget(),
  };
}
