import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/hive_registrar.g.dart';
import 'package:shelfo/provider/business/business_provider.dart';
import 'package:shelfo/provider/business/invoice_provider.dart';
import 'package:shelfo/provider/business/navigation_provider.dart';
import 'package:shelfo/provider/business/notification_provider.dart';
import 'package:shelfo/provider/business/tax_provider.dart';
import 'package:shelfo/provider/business/theme_provider.dart';
import 'package:shelfo/provider/customer/customer_provider.dart';
import 'package:shelfo/provider/inventory/brand_provider.dart';
import 'package:shelfo/provider/inventory/category_provider.dart';
import 'package:shelfo/provider/inventory/product_provider.dart';
import 'package:shelfo/provider/policy/policy_form_provider.dart';
import 'package:shelfo/provider/policy/policy_provider.dart';
import 'package:shelfo/provider/purchase/purchase_order_provider.dart';
import 'package:shelfo/provider/purchase/vendor_provider.dart';
import 'package:shelfo/provider/reports/report_provider.dart';
import 'package:shelfo/provider/sales/cart_provider.dart';
import 'package:shelfo/provider/sales/pos_provider.dart';
import 'package:shelfo/provider/sales/sale_provider.dart';
import 'package:shelfo/provider/sales/sales_order_provider.dart';
import 'package:shelfo/provider/service_job/service_job_provider.dart';
import 'package:shelfo/provider/splash/splash_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/services/notification/local_notification_service.dart';
import 'package:shelfo/utils/theme/theme.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    Hive.registerAdapters();
    await LocalNotificationService.init();
  } catch (e) {
    debugPrint("Initialization error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => TaxProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => SalesOrderProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => PurchaseOrderProvider()),
        ChangeNotifierProxyProvider<SaleProvider, CustomerProvider>(
          create: (context) => CustomerProvider(
            saleProvider: context.read<SaleProvider>(),
          ),
          update: (context, saleProvider, previous) =>
              previous!..update(saleProvider),
        ),
        ChangeNotifierProvider(create: (_) => ServiceJobProvider()),
        ChangeNotifierProvider(create: (_) => PolicyProvider()),
        ChangeNotifierProvider(create: (_) => PolicyFormProvider()),
        ChangeNotifierProxyProvider3<SaleProvider, ProductProvider, CategoryProvider, ReportProvider>(
          create: (context) => ReportProvider(
            saleProvider: context.read<SaleProvider>(),
            productProvider: context.read<ProductProvider>(),
            categoryProvider: context.read<CategoryProvider>(),
          ),
          update: (context, saleProvider, productProvider, categoryProvider, previous) =>
              previous!..update(saleProvider, productProvider, categoryProvider),
        ),
        ChangeNotifierProxyProvider5<ProductProvider, PurchaseOrderProvider, SaleProvider, ServiceJobProvider, BusinessProvider, NotificationProvider>(
          create: (context) => NotificationProvider(
            productProvider: context.read<ProductProvider>(),
            purchaseOrderProvider: context.read<PurchaseOrderProvider>(),
            saleProvider: context.read<SaleProvider>(),
            serviceJobProvider: context.read<ServiceJobProvider>(),
            businessProvider: context.read<BusinessProvider>(),
          ),
          update: (context, productProvider, poProvider, saleProvider, jobProvider, businessProvider, previous) =>
              previous!..update(
                productProvider: productProvider,
                purchaseOrderProvider: poProvider,
                saleProvider: saleProvider,
                serviceJobProvider: jobProvider,
                businessProvider: businessProvider,
              ),
        ),
        ChangeNotifierProvider(create: (_) => PosProvider()),
        ChangeNotifierProxyProvider<TaxProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, taxProvider, cartProvider) =>
              cartProvider!..updateTaxProvider(taxProvider),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(375, 812),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              // Get the screen width safely using View.of(context)
              // This avoids the 'MediaQuery.of(context)' dependency during startup
              final double width = View.of(context).physicalSize.width / View.of(context).devicePixelRatio;
              
              // Apply dynamic design size based on breakpoints
              final Size designSize = width >= 1024 
                  ? const Size(1440, 900) 
                  : width >= 600 
                      ? const Size(768, 1024) 
                      : const Size(375, 812);

              return ScreenUtilInit(
                designSize: designSize,
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return MaterialApp(
                    navigatorKey: LocalNotificationService.navigatorKey,
                    debugShowCheckedModeBanner: false,
                    title: 'Shelfo inventory',
                    theme: SFOAppTheme.light,
                    darkTheme: SFOAppTheme.dark,
                    themeMode: themeProvider.themeMode,
                    initialRoute: AppRoutes.splash,
                    routes: AppRoutes.routes,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

