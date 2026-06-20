import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/product/product_model.dart';
import '../../models/purchase/purchase_order_model.dart';
import '../../models/sale/sale_model.dart';
import '../inventory/category_provider.dart';
import '../inventory/product_provider.dart';
import '../purchase/purchase_order_provider.dart';
import '../sales/sale_provider.dart';

enum ReportPeriod {
  today,
  yesterday,
  last7Days,
  last30Days,
  thisMonth,
  thisYear,
  custom,
}

extension ReportPeriodExtension on ReportPeriod {
  String get label {
    switch (this) {
      case ReportPeriod.today: return "Today";
      case ReportPeriod.yesterday: return "Yesterday";
      case ReportPeriod.last7Days: return "Last 7 Days";
      case ReportPeriod.last30Days: return "Last 30 Days";
      case ReportPeriod.thisMonth: return "This Month";
      case ReportPeriod.thisYear: return "This Year";
      case ReportPeriod.custom: return "Custom Range";
    }
  }
}

class ReportProvider extends ChangeNotifier {
  // Providers
  SaleProvider? _saleProvider;
  ProductProvider? _productProvider;
  CategoryProvider? _categoryProvider;
  PurchaseOrderProvider? _purchaseProvider;

  // State
  ReportPeriod _selectedPeriod = ReportPeriod.last7Days;
  DateTimeRange? _customRange;

  // Getters
  ReportPeriod get selectedPeriod => _selectedPeriod;
  DateTimeRange? get customRange => _customRange;

  ReportProvider({
    SaleProvider? saleProvider,
    ProductProvider? productProvider,
    CategoryProvider? categoryProvider,
    PurchaseOrderProvider? purchaseProvider,
  })  : _saleProvider = saleProvider,
        _productProvider = productProvider,
        _categoryProvider = categoryProvider,
        _purchaseProvider = purchaseProvider;

  // Update Logic
  void update(
    SaleProvider saleProvider,
    ProductProvider productProvider,
    CategoryProvider categoryProvider,
    PurchaseOrderProvider purchaseProvider,
  ) {
    _saleProvider = saleProvider;
    _productProvider = productProvider;
    _categoryProvider = categoryProvider;
    _purchaseProvider = purchaseProvider;
    notifyListeners();
  }

  // Configuration
  void setPeriod(ReportPeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setCustomRange(DateTimeRange range) {
    _selectedPeriod = ReportPeriod.custom;
    _customRange = range;
    notifyListeners();
  }

  // Formatting
  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
  String _format(double value) => _currencyFormat.format(value);

  // Private Data Accessors
  List<Product> get _allProducts => _productProvider?.products ?? [];
  Map<String, Product> get _productMap => {for (var p in _allProducts) p.id: p};
  
  List<Sale> get _paidSales => _saleProvider?.sales.where((s) => s.status == 'Paid').toList() ?? [];

  // Filtering Logic
  ({DateTime start, DateTime end}) _getDateRange() {
    final now = DateTime.now();
    DateTime start;
    DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    switch (_selectedPeriod) {
      case ReportPeriod.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case ReportPeriod.yesterday:
        start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1));
        end = DateTime(now.year, now.month, now.day).subtract(const Duration(seconds: 1));
        break;
      case ReportPeriod.last7Days:
        start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
        break;
      case ReportPeriod.last30Days:
        start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 29));
        break;
      case ReportPeriod.thisMonth:
        start = DateTime(now.year, now.month, 1);
        break;
      case ReportPeriod.thisYear:
        start = DateTime(now.year, 1, 1);
        break;
      case ReportPeriod.custom:
        if (_customRange != null) {
          start = DateTime(_customRange!.start.year, _customRange!.start.month, _customRange!.start.day);
          end = DateTime(_customRange!.end.year, _customRange!.end.month, _customRange!.end.day, 23, 59, 59);
        } else {
          start = DateTime(now.year, now.month, now.day);
        }
        break;
    }
    return (start: start, end: end);
  }

  List<Sale> get _filteredSalesByPeriod {
    final range = _getDateRange();
    return _paidSales.where((s) => 
      s.dateTime.isAfter(range.start.subtract(const Duration(seconds: 1))) && 
      s.dateTime.isBefore(range.end.add(const Duration(seconds: 1)))
    ).toList();
  }

  List<PurchaseOrder> get _filteredPurchasesByPeriod {
    final range = _getDateRange();
    return (_purchaseProvider?.allOrders ?? []).where((p) => 
      p.status != PurchaseOrderStatus.cancelled &&
      p.date.isAfter(range.start.subtract(const Duration(seconds: 1))) && 
      p.date.isBefore(range.end.add(const Duration(seconds: 1)))
    ).toList();
  }

  // --- Financial Metrics ---

  String get totalRevenue {
    double total = _filteredSalesByPeriod.fold(0.0, (sum, sale) => sum + sale.total);
    return _format(total);
  }

  String get grossProfit {
    double revenue = _filteredSalesByPeriod.fold(0.0, (sum, sale) => sum + sale.total);
    double cog = _calculateCOG(_filteredSalesByPeriod);
    return _format(revenue - cog);
  }

  double _calculateCOG(List<Sale> sales) {
    double cog = 0;
    final products = _productMap;
    for (var sale in sales) {
      for (var item in sale.items) {
        final product = products[item.productId];
        cog += item.quantity * (product?.costPrice ?? 0);
      }
    }
    return cog;
  }

  String get netProfitMargin {
    double revenue = _filteredSalesByPeriod.fold(0.0, (sum, sale) => sum + sale.total);
    if (revenue == 0) return "0.0 %";
    double cog = _calculateCOG(_filteredSalesByPeriod);
    double expenses = _filteredPurchasesByPeriod.fold(0.0, (double sum, p) => sum + p.total);
    double profit = revenue - cog - expenses;
    return "${((profit / revenue) * 100).toStringAsFixed(1)} %";
  }

  String get costOfGoods => _format(_calculateCOG(_filteredSalesByPeriod));
  
  String get operatingExpenses {
    double total = _filteredPurchasesByPeriod.fold(0.0, (double sum, p) => sum + p.total);
    return _format(total);
  }

  String get revenueTrend => "+0.0%"; // Placeholder
  String get profitTrend => "+0.0%"; // Placeholder

  // --- Inventory & Products ---

  int get totalItems => _allProducts.length;

  String get inventoryValue {
    double total = _allProducts.fold(0.0, (sum, p) => sum + (p.costPrice * p.stockQuantity));
    return _format(total);
  }

  String get inventorySubtitle => "${_allProducts.fold(0, (sum, p) => sum + p.stockQuantity)} items in stock";

  String get activeCustomers {
    final customers = _filteredSalesByPeriod.map((s) => s.customerName).toSet();
    return customers.length.toString();
  }

  String get customersTrend => "Ok";

  /// Returns products sorted by their total profit contribution in the selected period.
  List<Map<String, dynamic>> get profitProducts {
    Map<String, double> productProfits = {};
    final products = _productMap;

    for (var sale in _filteredSalesByPeriod) {
      for (var item in sale.items) {
        final product = products[item.productId];
        final cost = (product?.costPrice ?? 0) * item.quantity;
        final profit = item.total - cost;
        productProfits[item.productName] = (productProfits[item.productName] ?? 0.0) + profit;
      }
    }

    // Fallback to all products if no sales
    if (productProfits.isEmpty) {
      return _allProducts.take(10).map((p) => {
        "name": p.name,
        "sku": p.sku ?? "N/A",
        "cost": _format(p.costPrice),
        "selling": _format(p.price),
      }).toList();
    }

    var sorted = productProfits.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(10).map((e) {
      // Find SKU and prices from _allProducts if possible
      final product = _allProducts.where((p) => p.name == e.key).firstOrNull;
      return {
        "name": e.key,
        "sku": product?.sku ?? "N/A",
        "cost": _format(product?.costPrice ?? 0),
        "selling": _format(product?.price ?? 0),
      };
    }).toList();
  }

  List<Map<String, dynamic>> get topProducts {
    Map<String, int> productUnits = {};
    Map<String, double> productRevenue = {};

    for (var sale in _filteredSalesByPeriod) {
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

  // --- Category Breakdown ---

  List<Map<String, dynamic>> get categories {
    final hiveCategories = _categoryProvider?.categories ?? [];
    Map<String, int> categoryCount = {};
    
    for (var cat in hiveCategories) {
      categoryCount[cat.name] = 0;
    }

    for (var p in _allProducts) {
      final catName = p.categoryName ?? "Uncategorized";
      categoryCount[catName] = (categoryCount[catName] ?? 0) + 1;
    }

    if (_allProducts.isEmpty) return [];

    return categoryCount.entries.map((e) => {
      "label": e.key,
      "value": e.value.toDouble(),
      "count": "${e.value} Items",
    }).toList();
  }

  // --- Chart Data ---

  List<FlSpot> getWeeklySalesSpots() {
    return _getSpotsForPeriod((sales) => sales.fold(0.0, (sum, s) => sum + s.total));
  }

  List<FlSpot> getWeeklyProfitSpots() {
    return _getSpotsForPeriod((sales) {
      double profit = 0;
      final products = _productMap;
      for (var sale in sales) {
        double cog = 0;
        for (var item in sale.items) {
          final product = products[item.productId];
          cog += item.quantity * (product?.costPrice ?? 0);
        }
        profit += (sale.total - cog);
      }
      return profit;
    });
  }

  List<FlSpot> _getSpotsForPeriod(double Function(List<Sale>) aggregator) {
    final range = _getDateRange();
    int days = range.end.difference(range.start).inDays + 1;

    List<FlSpot> spots = [];
    for (int i = 0; i < days; i++) {
      final date = range.start.add(Duration(days: i));
      final dailySales = _paidSales.where((s) => 
        s.dateTime.year == date.year && 
        s.dateTime.month == date.month && 
        s.dateTime.day == date.day
      ).toList();
      spots.add(FlSpot(i.toDouble(), aggregator(dailySales)));
    }
    return spots;
  }
  
  List<String> getChartLabels() {
    final range = _getDateRange();
    int days = range.end.difference(range.start).inDays + 1;

    List<String> labels = [];
    for (int i = 0; i < days; i++) {
       final date = range.start.add(Duration(days: i));
       if (days <= 7) {
         labels.add(DateFormat('EEE').format(date));
       } else {
         labels.add(DateFormat('MMM dd').format(date));
       }
    }
    return labels;
  }
}
