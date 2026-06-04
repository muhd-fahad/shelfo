import 'package:flutter/material.dart';
import '../models/customer/customer_model.dart';
import '../models/sale/sale_model.dart';
import '../services/hive/customer_service.dart';
import 'sale_provider.dart';

class CustomerProvider extends ChangeNotifier {
  SaleProvider? _saleProvider;
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String _searchQuery = '';
  final List<String> _filterStatuses = []; // Active, Credit, Overdue
  String? _selectedCustomerId;

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  List<String> get filterStatuses => _filterStatuses;
  String? get selectedCustomerId => _selectedCustomerId;

  CustomerProvider({SaleProvider? saleProvider}) : _saleProvider = saleProvider {
    loadCustomers();
  }

  void update(SaleProvider saleProvider) {
    _saleProvider = saleProvider;
    _applyFilter();
    notifyListeners();
  }

  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    _customers = await CustomerHiveService.getAllCustomers();
    _applyFilter();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void toggleFilterStatus(String status) {
    if (status == 'All') {
      _filterStatuses.clear();
    } else {
      if (_filterStatuses.contains(status)) {
        _filterStatuses.remove(status);
      } else {
        _filterStatuses.add(status);
      }
    }
    _applyFilter();
    notifyListeners();
  }

  void setSelectedCustomer(String? id) {
    _selectedCustomerId = id;
    notifyListeners();
  }

  Customer? get selectedCustomer {
    if (_selectedCustomerId == null) return null;
    return _customers.where((c) => c.id == _selectedCustomerId).firstOrNull;
  }

  List<Sale> get customerSales {
    final customer = selectedCustomer;
    if (customer == null || _saleProvider == null) return [];
    final name = customer.name;
    return _saleProvider!.sales.where((s) => s.customerName == name).toList();
  }

  double get totalPurchases {
    return customerSales.fold(0.0, (sum, s) => sum + s.total);
  }

  void _applyFilter() {
    List<Customer> results = _customers;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((c) => 
        c.name.toLowerCase().contains(query) || 
        (c.phone?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // Status filter
    if (_filterStatuses.isNotEmpty) {
      results = results.where((customer) {
        final hasSales = _saleProvider?.sales.any((s) => s.customerName == customer.name) ?? false;
        final outstanding = getOutstanding(customer);

        bool matches = false;
        if (_filterStatuses.contains('Active') && hasSales) matches = true;
        if (_filterStatuses.contains('Credit') && outstanding > 0) matches = true;
        if (_filterStatuses.contains('Overdue') && outstanding > 0) matches = true;
        
        return matches;
      }).toList();
    }

    _filteredCustomers = results;
  }

  // UI Helpers
  double getOutstanding(Customer customer) {
    // Placeholder: In a real app, this would check unpaid invoices
    // For now, let's simulate logic: if customer has 'Credit' in name or special ID
    return 0.0; 
  }

  double getProgress(Customer customer) {
    final outstanding = getOutstanding(customer);
    if (customer.creditLimit <= 0) return 0.0;
    return (outstanding / customer.creditLimit).clamp(0.0, 1.0);
  }

  Future<void> addCustomer(Customer customer) async {
    await CustomerHiveService.saveCustomer(customer);
    await loadCustomers();
  }

  Future<void> updateCustomer(Customer customer) async {
    await CustomerHiveService.saveCustomer(customer);
    await loadCustomers();
  }

  Future<void> deleteCustomer(String id) async {
    await CustomerHiveService.deleteCustomer(id);
    await loadCustomers();
  }
}
