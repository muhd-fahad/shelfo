import 'package:flutter/material.dart';
import 'package:shelfo/screens/customer/customer_list_screen.dart';
import 'package:shelfo/screens/onboard/business_info_screen.dart';
import 'package:shelfo/screens/onboard/invoice_settings_screen.dart';
import 'package:shelfo/screens/onboard/tax_config_screen.dart';
import 'package:shelfo/screens/pos/pos_screen.dart';
import 'package:shelfo/screens/purchase/purchasing_screen.dart';
import 'package:shelfo/screens/sales/sales_order_screen.dart';
import 'package:shelfo/screens/service_job/service_job_details_screen.dart';
import 'package:shelfo/screens/service_job/service_job_form_screen.dart';
import 'package:shelfo/screens/sales/sales_history_screen.dart';
import 'package:shelfo/screens/settings/brands_settings_screen.dart';
import 'package:shelfo/screens/settings/business_details_screen.dart';
import 'package:shelfo/screens/settings/invoice_settings_detail_screen.dart';
import 'package:shelfo/screens/settings/tax_settings_screen.dart';
import 'package:shelfo/screens/settings/policies_screen.dart';
import 'package:shelfo/screens/settings/privacy_policy_screen.dart';
import 'package:shelfo/screens/settings/about_screen.dart';
import 'package:shelfo/widgets/bottom_navbar/bottom_navbar_widget.dart';

import 'package:shelfo/screens/inventory/inventory_screen.dart';
import 'package:shelfo/screens/settings/settings_screen.dart';

import '../screens/home/home_screen.dart';
import '../screens/notifications/notification_screen.dart';
import '../screens/reports/report_screen.dart';
import '../screens/service_job/job_ticket_screen.dart';
import '../screens/settings/categories_settings_screen.dart';
import '../screens/splash/splash_screen.dart';

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
  static const String brandsSettings = '/brandsSettings';
  static const String pos = '/pos';
  static const String reports = '/reports';
  static const String salesHistory = '/salesHistory';
  static const String salesOrder = '/salesOrder';
  static const String purchaseOrder = '/purchaseOrder';
  static const String bottomNavbar = '/bottomNavbar';
  static const String customers = '/customers';
  static const String serviceJobs = '/serviceJobs';
  static const String serviceJobForm = '/serviceJobForm';
  static const String serviceJobDetails = '/serviceJobDetails';
  static const String policies = '/policies';
  static const String privacyPolicy = '/privacyPolicy';
  static const String about = '/about';

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
    brandsSettings: (context) => const BrandsSettingsScreen(),
    taxSettings: (context) => const TaxSettingsScreen(),
    invoiceDetails: (context) => const InvoiceSettingsDetailScreen(),
    pos: (context) => const PosScreen(),
    reports: (context) => const ReportScreen(),
    salesHistory: (context) => const SalesHistoryScreen(),
    salesOrder: (context) => const SalesOrderScreen(),
    purchaseOrder: (context) => const PurchasingScreen(),
    bottomNavbar: (context) => const BottomNavbarWidget(),
    customers: (context) => const CustomerListScreen(),
    serviceJobs: (context) => const JobTicketScreen(),
    serviceJobForm: (context) => const ServiceJobFormScreen(),
    serviceJobDetails: (context) => const ServiceJobDetailsScreen(),
    policies: (context) => const PoliciesScreen(),
    privacyPolicy: (context) => const PrivacyPolicyScreen(),
    about: (context) => const AboutScreen(),
  };
}
