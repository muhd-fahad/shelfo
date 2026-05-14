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
  String _filterStatus = 'All'; // All, Active, Credit, Overdue
  String? _selectedCustomerId;

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;
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

  void setFilterStatus(String status) {
    _filterStatus = status;
    _applyFilter();
    notifyListeners();
  }

  void setSelectedCustomer(String? id) {
    _selectedCustomerId = id;
    notifyListeners();
  }

  Customer get selectedCustomer => 
      _customers.firstWhere((c) => c.id == _selectedCustomerId);

  List<Sale> get customerSales {
    if (_selectedCustomerId == null || _saleProvider == null) return [];
    final name = selectedCustomer.name;
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
    if (_filterStatus != 'All') {
      results = results.where((customer) {
        final hasSales = _saleProvider?.sales.any((s) => s.customerName == customer.name) ?? false;
        final outstanding = getOutstanding(customer);

        switch (_filterStatus) {
          case 'Active':
            return hasSales;
          case 'Credit':
            return outstanding > 0;
          case 'Overdue':
            // For now, same as credit since we don't have due dates
            return outstanding > 0;
          default:
            return true;
        }
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
