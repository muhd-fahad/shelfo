import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/sale_provider.dart';
import '../models/product/product_model.dart';
import '../models/sale/sale_model.dart';

class ReportProvider extends ChangeNotifier {
  SaleProvider? _saleProvider;
  ProductProvider? _productProvider;
  CategoryProvider? _categoryProvider;

  ReportProvider({
    SaleProvider? saleProvider,
    ProductProvider? productProvider,
    CategoryProvider? categoryProvider,
  })  : _saleProvider = saleProvider,
        _productProvider = productProvider,
        _categoryProvider = categoryProvider;

  void update(
    SaleProvider saleProvider,
    ProductProvider productProvider,
    CategoryProvider categoryProvider,
  ) {
    _saleProvider = saleProvider;
    _productProvider = productProvider;
    _categoryProvider = categoryProvider;
    notifyListeners();
  }

  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  String _format(double value) => _currencyFormat.format(value);

  List<Sale> get _paidSales => _saleProvider?.sales.where((s) => s.status == 'Paid').toList() ?? [];
  List<Product> get _allProducts => _productProvider?.products ?? [];

  String get totalRevenue {
    double total = _paidSales.fold(0.0, (sum, sale) => sum + sale.total);
    return _format(total);
  }

  String get revenueTrend => "+0.0%"; // Placeholder

  String get grossProfit {
    double totalRevenue = _paidSales.fold(0.0, (sum, sale) => sum + sale.total);
    double cog = _calculateCOG();
    return _format(totalRevenue - cog);
  }

  double _calculateCOG() {
    double cog = 0;
    for (var sale in _paidSales) {
      for (var item in sale.items) {
        final product = _allProducts.where((p) => p.id == item.productId).firstOrNull;
        cog += item.quantity * (product?.costPrice ?? 0);
      }
    }
    return cog;
  }

  String get profitTrend => "+0.0%"; // Placeholder

  String get inventoryValue {
    double total = _allProducts.fold(0.0, (sum, p) => sum + (p.costPrice * p.stockQuantity));
    return _format(total);
  }

  String get inventorySubtitle => "${_allProducts.fold(0, (sum, p) => sum + p.stockQuantity)} items in stock";

  String get activeCustomers {
    final customers = _paidSales.map((s) => s.customerName).toSet();
    return customers.length.toString();
  }

  String get customersTrend => "Ok";

  String get netProfitMargin {
    double revenue = _paidSales.fold(0.0, (sum, sale) => sum + sale.total);
    if (revenue == 0) return "0.0 %";
    double cog = _calculateCOG();
    double profit = revenue - cog;
    return "${((profit / revenue) * 100).toStringAsFixed(1)} %";
  }

  String get costOfGoods => _format(_calculateCOG());
  
  String get operatingExpenses => "₹ 0";

  List<Map<String, dynamic>> get topProducts {
    Map<String, int> productUnits = {};
    Map<String, double> productRevenue = {};

    for (var sale in _paidSales) {
      for (var item in sale.items) {
        productUnits[item.productName] = (productUnits[item.productName] ?? 0) + item.quantity;
        productRevenue[item.productName] = (productRevenue[item.productName] ?? 0.0) + item.total;
      }
    }

    var sortedProducts = productUnits.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedProducts.take(5).map((e) => {
      "name": e.key,
      "sold": e.value.toString(),
      "revenue": _format(productRevenue[e.key] ?? 0.0),
    }).toList();
  }

  List<Map<String, dynamic>> get profitProducts {
    return _allProducts.take(10).map((p) => {
      "name": p.name,
      "sku": p.sku ?? "N/A",
      "cost": _format(p.costPrice),
      "selling": _format(p.price),
    }).toList();
  }

  List<Map<String, dynamic>> get inventoryStats {
    int totalItems = _allProducts.length;
    int lowStock = _allProducts.where((p) => p.stockQuantity <= p.minStock && p.stockQuantity > 0).length;
    int outOfStock = _allProducts.where((p) => p.stockQuantity <= 0).length;
    double totalVal = _allProducts.fold(0.0, (sum, p) => sum + (p.costPrice * p.stockQuantity));

    return [
      {"title": "Total Items", "value": totalItems.toString(), "icon": Icons.inventory_2_outlined, "color": Colors.blue},
      {"title": "Low Stock Items", "value": lowStock.toString(), "icon": Icons.trending_up, "color": Colors.orange},
      {"title": "Out of Stock", "value": outOfStock.toString(), "icon": Icons.trending_down, "color": Colors.red},
      {"title": "Total Value", "value": _format(totalVal), "icon": Icons.attach_money, "color": Colors.green},
    ];
  }

  List<Map<String, dynamic>> get lowStockItems {
    return _allProducts
        .where((p) => p.stockQuantity <= p.minStock)
        .take(5)
        .map((p) => {
          "name": p.name,
          "status": p.stockQuantity <= 0 ? "Out of Stock" : "${p.stockQuantity} Left",
          "subtitle": "Min: ${p.minStock} • Reorder: ${p.reorderPoint}",
          "color": p.stockQuantity <= 0 ? Colors.red : Colors.orange,
        }).toList();
  }

  int get totalItems => _allProducts.length;

  List<Map<String, dynamic>> get categories {
    final hiveCategories = _categoryProvider?.categories ?? [];
    Map<String, int> categoryCount = {};
    
    // Initialize with all hive categories to show empty ones too
    for (var cat in hiveCategories) {
      categoryCount[cat.name] = 0;
    }

    for (var p in _allProducts) {
      final catName = p.categoryName ?? "Uncategorized";
      categoryCount[catName] = (categoryCount[catName] ?? 0) + 1;
    }

    int total = _allProducts.length;
    if (total == 0) return [];

    return categoryCount.entries.map((e) => {
      "label": e.key,
      "value": e.value.toDouble(),
      "count": "${e.value} Items",
    }).toList();
  }

  // Real Data for Charts
  List<FlSpot> getWeeklySalesSpots() {
    final now = DateTime.now();
    List<FlSpot> spots = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailyTotal = _paidSales
          .where((s) => s.dateTime.year == date.year && s.dateTime.month == date.month && s.dateTime.day == date.day)
          .fold(0.0, (sum, s) => sum + s.total);
      spots.add(FlSpot((6 - i).toDouble(), dailyTotal));
    }
    return spots;
  }

  List<FlSpot> getWeeklyProfitSpots() {
    final now = DateTime.now();
    List<FlSpot> spots = [];
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailySales = _paidSales.where((s) => s.dateTime.year == date.year && s.dateTime.month == date.month && s.dateTime.day == date.day);
      double dailyProfit = 0;
      for (var sale in dailySales) {
        double cog = 0;
        for (var item in sale.items) {
          final product = _allProducts.where((p) => p.id == item.productId).firstOrNull;
          cog += item.quantity * (product?.costPrice ?? 0);
        }
        dailyProfit += (sale.total - cog);
      }
      spots.add(FlSpot((6 - i).toDouble(), dailyProfit));
    }
    return spots;
  }
}
