import 'package:flutter/material.dart';
import '../models/sale/sales_order_model.dart';
import '../services/hive/hive_service.dart';
import 'product_provider.dart';

class SalesOrderProvider extends ChangeNotifier {
  List<SalesOrder> _orders = [];
  List<SalesOrder> _filteredOrders = [];
  bool _isLoading = false;
  String _searchQuery = '';
  SalesOrderStatus _statusFilter = SalesOrderStatus.all;
  
  // Advanced filters
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController minAmountController = TextEditingController();
  final TextEditingController maxAmountController = TextEditingController();

  List<SalesOrder> get orders => _filteredOrders;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  SalesOrderStatus get statusFilter => _statusFilter;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  SalesOrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    _isLoading = true;
    notifyListeners();

    final box = await HiveService.getBox<SalesOrder>(HiveService.salesOrdersBox);
    _orders = box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setStatusFilter(SalesOrderStatus status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
    notifyListeners();
  }

  void applyAdvancedFilters() {
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _searchQuery = '';
    _statusFilter = SalesOrderStatus.all;
    _startDate = null;
    _endDate = null;
    minAmountController.clear();
    maxAmountController.clear();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredOrders = _orders.where((order) {
      final matchesSearch = order.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _statusFilter == SalesOrderStatus.all || order.status == _statusFilter;

      bool matchesDate = true;
      if (_startDate != null) {
        matchesDate = order.date.isAfter(_startDate!) || order.date.isAtSameMomentAs(_startDate!);
      }
      if (matchesDate && _endDate != null) {
        matchesDate = order.date.isBefore(_endDate!) || order.date.isAtSameMomentAs(_endDate!);
      }

      final min = double.tryParse(minAmountController.text);
      final max = double.tryParse(maxAmountController.text);
      
      bool matchesAmount = true;
      if (min != null) matchesAmount = order.total >= min;
      if (matchesAmount && max != null) matchesAmount = order.total <= max;

      return matchesSearch && matchesStatus && matchesDate && matchesAmount;
    }).toList();
  }

  Future<void> addOrder(SalesOrder order, {ProductProvider? productProvider}) async {
    final box = await HiveService.getBox<SalesOrder>(HiveService.salesOrdersBox);
    await box.add(order);
    _orders.insert(0, order);

    // Reflect stock if order is fulfilled or just created (per user request)
    if (productProvider != null && order.status != SalesOrderStatus.cancelled && order.status != SalesOrderStatus.draft) {
      for (var item in order.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: false);
        } catch (e) {
          debugPrint("Product not found for stock update: ${item.productId}");
        }
      }
    }

    _applyFilters();
    notifyListeners();
  }

  Future<void> updateOrder(SalesOrder oldOrder, SalesOrder newOrder) async {
    final index = _orders.indexWhere((o) => o.id == oldOrder.id);
    if (index != -1) {
      await oldOrder.delete(); // Remove old from hive
      final box = await HiveService.getBox<SalesOrder>(HiveService.salesOrdersBox);
      await box.add(newOrder);
      
      _orders[index] = newOrder;
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(SalesOrder order, SalesOrderStatus status, {ProductProvider? productProvider}) async {
    final oldStatus = order.status;
    order.status = status;
    await order.save();

    if (productProvider != null) {
      // If order moves to a state that requires stock reduction (Pending/Fulfilled) 
      // from a state that doesn't (Draft/Cancelled)
      bool oldRequiresReduction = oldStatus != SalesOrderStatus.draft && oldStatus != SalesOrderStatus.cancelled;
      bool newRequiresReduction = status != SalesOrderStatus.draft && status != SalesOrderStatus.cancelled;

      if (!oldRequiresReduction && newRequiresReduction) {
        // Reduce stock
        for (var item in order.items) {
          try {
            final product = productProvider.products.firstWhere((p) => p.id == item.productId);
            await productProvider.adjustStock(product, item.quantity, isAddition: false);
          } catch (e) {
            debugPrint("Product not found for stock update: ${item.productId}");
          }
        }
      } 
      // If order moves from a reduced state to a non-reduced state (e.g. Cancelled)
      else if (oldRequiresReduction && !newRequiresReduction) {
        // Return stock
        for (var item in order.items) {
          try {
            final product = productProvider.products.firstWhere((p) => p.id == item.productId);
            await productProvider.adjustStock(product, item.quantity, isAddition: true);
          } catch (e) {
            debugPrint("Product not found for stock update: ${item.productId}");
          }
        }
      }
    }

    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteOrder(SalesOrder order, {ProductProvider? productProvider}) async {
    if (productProvider != null && order.status != SalesOrderStatus.cancelled && order.status != SalesOrderStatus.draft) {
      // Return stock if it was already reduced
      for (var item in order.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: true);
        } catch (e) {
          debugPrint("Product not found for stock return: ${item.productId}");
        }
      }
    }
    await order.delete();
    _orders.removeWhere((o) => o.id == order.id);
    _applyFilters();
    notifyListeners();
  }

  @override
  void dispose() {
    minAmountController.dispose();
    maxAmountController.dispose();
    super.dispose();
  }
}
