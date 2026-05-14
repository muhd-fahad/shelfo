import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/hive_registrar.g.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/navigation_provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/provider/brand_provider.dart';
import 'package:shelfo/provider/invoice_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/cart_provider.dart';
import 'package:shelfo/provider/pos_provider.dart';
import 'package:shelfo/provider/theme_provider.dart';
import 'package:shelfo/provider/tax_provider.dart';
import 'package:shelfo/provider/customer_provider.dart';
import 'package:shelfo/provider/sale_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapters();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => BusinessProvider()),
        ChangeNotifierProvider(create: (_) => TaxProvider()),
        ChangeNotifierProvider(create: (_) => InvoiceProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => BrandProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProxyProvider<SaleProvider, CustomerProvider>(
          create: (context) => CustomerProvider(
            saleProvider: context.read<SaleProvider>(),
          ),
          update: (context, saleProvider, previous) =>
              previous!..update(saleProvider),
        ),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => PosProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shelfo inventory',
            theme: SFOAppTheme.light,
            darkTheme: SFOAppTheme.dark,
            themeMode: themeProvider.themeMode,
            initialRoute: AppRoutes.splash,
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
