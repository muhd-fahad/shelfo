import 'package:flutter/material.dart';
import '../models/customer/customer_model.dart';
import '../services/hive/customer_service.dart';

class CustomerProvider extends ChangeNotifier {
  List<Customer> _customers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _filterStatus = 'All'; // All, Active, Credit, Overdue

  List<Customer> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  CustomerProvider() {
    loadCustomers();
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

  void _applyFilter() {
    List<Customer> results = _customers;

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((c) => 
        c.name.toLowerCase().contains(query) || 
        (c.phone?.toLowerCase().contains(query) ?? false)
      ).toList();
    }

    // TODO: Implement actual logic for Active, Credit, Overdue once sales/outstanding is linked
    if (_filterStatus != 'All') {
      // Placeholder logic
    }

    _filteredCustomers = results;
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
