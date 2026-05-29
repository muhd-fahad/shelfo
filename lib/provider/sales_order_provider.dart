import 'package:flutter/material.dart';
import '../models/sale/sales_order_model.dart';

class SalesOrderProvider extends ChangeNotifier {
  final List<SalesOrder> _orders = [
    SalesOrder(
      id: "SO-2024-001",
      date: DateTime(2024, 10, 24),
      customerName: "Gadget Corner",
      items: [],
      subtotal: 9184,
      taxAmount: 0,
      total: 9184,
      status: SalesOrderStatus.fulfilled,
    ),
    SalesOrder(
      id: "SO-2024-002",
      date: DateTime(2024, 10, 24),
      customerName: "Juan Dela Cruz",
      items: [],
      subtotal: 18999,
      taxAmount: 2280,
      total: 21279,
      status: SalesOrderStatus.pending,
      notes: "Rush delivery",
    ),
    SalesOrder(
      id: "SO-2024-003",
      date: DateTime(2024, 10, 23),
      customerName: "City Repair Shop",
      items: [],
      subtotal: 9184,
      taxAmount: 0,
      total: 9184,
      status: SalesOrderStatus.fulfilled,
    ),
    SalesOrder(
      id: "SO-2024-004",
      date: DateTime(2024, 10, 23),
      customerName: "Cyber Cafe 24/7",
      items: [],
      subtotal: 47600,
      taxAmount: 0,
      total: 47600,
      status: SalesOrderStatus.inTransit,
    ),
    SalesOrder(
      id: "SO-2024-005",
      date: DateTime(2024, 10, 22),
      customerName: "Maria Santos",
      items: [],
      subtotal: 2800,
      taxAmount: 0,
      total: 2800,
      status: SalesOrderStatus.cancelled,
    ),
    SalesOrder(
      id: "SO-2024-006",
      date: DateTime(2024, 10, 22),
      customerName: "Cyber Cafe 24/7",
      items: [],
      subtotal: 201598,
      taxAmount: 0,
      total: 201598,
      status: SalesOrderStatus.draft,
    ),
  ];
  List<SalesOrder> _filteredOrders = [];
  final bool _isLoading = false;
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
    _applyFilters();
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

  void addOrder(SalesOrder order) {
    _orders.insert(0, order);
    _applyFilters();
    notifyListeners();
  }

  void updateOrder(SalesOrder oldOrder, SalesOrder newOrder) {
    final index = _orders.indexOf(oldOrder);
    if (index != -1) {
      _orders[index] = newOrder;
      _applyFilters();
      notifyListeners();
    }
  }

  void updateOrderStatus(SalesOrder order, SalesOrderStatus status) {
    order.status = status;
    _applyFilters();
    notifyListeners();
  }

  void deleteOrder(SalesOrder order) {
    _orders.remove(order);
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
