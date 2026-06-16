import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/sale_provider.dart';
import '../models/product/product_model.dart';
import '../models/sale/sale_model.dart';

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
  SaleProvider? _saleProvider;
  ProductProvider? _productProvider;
  CategoryProvider? _categoryProvider;

  ReportPeriod _selectedPeriod = ReportPeriod.last7Days;
  ReportPeriod get selectedPeriod => _selectedPeriod;

  DateTimeRange? _customRange;
  DateTimeRange? get customRange => _customRange;

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

  void setPeriod(ReportPeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  void setCustomRange(DateTimeRange range) {
    _selectedPeriod = ReportPeriod.custom;
    _customRange = range;
    notifyListeners();
  }

  final _currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  String _format(double value) => _currencyFormat.format(value);

  List<Sale> get _paidSales => _saleProvider?.sales.where((s) => s.status == 'Paid').toList() ?? [];
  
  List<Sale> get _filteredSalesByPeriod {
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

    return _paidSales.where((s) => s.dateTime.isAfter(start.subtract(const Duration(seconds: 1))) && s.dateTime.isBefore(end.add(const Duration(seconds: 1)))).toList();
  }

  List<Product> get _allProducts => _productProvider?.products ?? [];

  String get totalRevenue {
    double total = _filteredSalesByPeriod.fold(0.0, (sum, sale) => sum + sale.total);
    return _format(total);
  }

  String get revenueTrend => "+0.0%"; // Placeholder

  String get grossProfit {
    double totalRevenue = _filteredSalesByPeriod.fold(0.0, (sum, sale) => sum + sale.total);
    double cog = _calculateCOG(_filteredSalesByPeriod);
    return _format(totalRevenue - cog);
  }

  double _calculateCOG(List<Sale> sales) {
    double cog = 0;
    for (var sale in sales) {
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
    final customers = _filteredSalesByPeriod.map((s) => s.customerName).toSet();
    return customers.length.toString();
  }

  String get customersTrend => "Ok";

  String get netProfitMargin {
    double revenue = _filteredSalesByPeriod.fold(0.0, (sum, sale) => sum + sale.total);
    if (revenue == 0) return "0.0 %";
    double cog = _calculateCOG(_filteredSalesByPeriod);
    double profit = revenue - cog;
    return "${((profit / revenue) * 100).toStringAsFixed(1)} %";
  }

  String get costOfGoods => _format(_calculateCOG(_filteredSalesByPeriod));
  
  String get operatingExpenses => "₹ 0";

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

  // Real Data for Charts based on selected period
  List<FlSpot> getWeeklySalesSpots() {
    return _getSpotsForPeriod((sales) => sales.fold(0.0, (sum, s) => sum + s.total));
  }

  List<FlSpot> getWeeklyProfitSpots() {
    return _getSpotsForPeriod((sales) {
      double profit = 0;
      for (var sale in sales) {
        double cog = 0;
        for (var item in sale.items) {
          final product = _allProducts.where((p) => p.id == item.productId).firstOrNull;
          cog += item.quantity * (product?.costPrice ?? 0);
        }
        profit += (sale.total - cog);
      }
      return profit;
    });
  }

  List<FlSpot> _getSpotsForPeriod(double Function(List<Sale>) aggregator) {
    final now = DateTime.now();
    int days = 7;
    if (_selectedPeriod == ReportPeriod.last30Days) days = 30;
    if (_selectedPeriod == ReportPeriod.thisMonth) {
       days = DateTime(now.year, now.month + 1, 0).day;
    }
    if (_selectedPeriod == ReportPeriod.custom && _customRange != null) {
      days = _customRange!.duration.inDays + 1;
    }

    List<FlSpot> spots = [];
    for (int i = days - 1; i >= 0; i--) {
      DateTime date;
      if (_selectedPeriod == ReportPeriod.thisMonth) {
         date = DateTime(now.year, now.month, days - i);
      } else if (_selectedPeriod == ReportPeriod.custom && _customRange != null) {
         date = _customRange!.start.add(Duration(days: days - 1 - i));
      } else {
         date = now.subtract(Duration(days: i));
      }
      
      final dailySales = _paidSales.where((s) => s.dateTime.year == date.year && s.dateTime.month == date.month && s.dateTime.day == date.day).toList();
      spots.add(FlSpot((days - 1 - i).toDouble(), aggregator(dailySales)));
    }
    return spots;
  }
  
  List<String> getChartLabels() {
    final now = DateTime.now();
    int days = 7;
    if (_selectedPeriod == ReportPeriod.last30Days) days = 30;
    if (_selectedPeriod == ReportPeriod.thisMonth) {
       days = DateTime(now.year, now.month + 1, 0).day;
    }
    if (_selectedPeriod == ReportPeriod.custom && _customRange != null) {
       days = _customRange!.duration.inDays + 1;
    }

    List<String> labels = [];
    for (int i = days - 1; i >= 0; i--) {
       DateTime date;
       if (_selectedPeriod == ReportPeriod.thisMonth) {
          date = DateTime(now.year, now.month, days - i);
       } else if (_selectedPeriod == ReportPeriod.custom && _customRange != null) {
          date = _customRange!.start.add(Duration(days: days - 1 - i));
       } else {
          date = now.subtract(Duration(days: i));
       }
       
       if (days <= 7) {
         labels.add(DateFormat('EEE').format(date));
       } else {
         labels.add(DateFormat('MMM dd').format(date));
       }
    }
    return labels;
  }
}
