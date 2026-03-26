
import 'package:flutter/material.dart';
import 'package:shelfo/screens/notification_screen.dart';
import 'package:shelfo/screens/onboard/business_info_screen.dart';
import 'package:shelfo/screens/onboard/invoice_settings_screen.dart';
import 'package:shelfo/screens/onboard/tax_config_screen.dart';
import 'package:shelfo/screens/purchase_order_screen.dart';
import 'package:shelfo/screens/sales_order_screen.dart';
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

  static const String notification = '/notification';
  static const String inventory = '/inventory';
  static const String settings = '/settings';
  static const String pos = '/pos';
  static const String reports = '/reports';
  static const String salesOrder = '/salesOrder';
  static const String purchaseOrder = '/purchaseOrder';
  static const String bottomNavbar = '/bottomNavbar';

  static final Map<String, Widget Function(BuildContext)> routes = {
    splash: (context) => SplashScreen(),
    home: (context) => HomeScreen(),
    businessInfo: (context) => BusinessInfoScreen(),
    taxConfig: (context) => TaxConfigScreen(),
    invoiceSettings: (context) => InvoiceSettingsScreen(),
    notification: (context)=> NotificationScreen(),
    inventory: (context)=> InventoryScreen(),
    settings: (context)=> SettingsScreen(),
    pos: (context)=> HomeScreen(),
    reports: (context)=> ReportScreen(),
    salesOrder: (context)=> SalesOrderScreen(),
    purchaseOrder: (context)=> PurchaseOrderScreen(),
    bottomNavbar: (context)=> BottomNavbarWidget(),

  };
}


