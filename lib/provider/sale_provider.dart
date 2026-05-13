import 'package:flutter/material.dart';
import '../models/sale/sale_model.dart';
import '../services/hive/sale_service.dart';
import '../models/invoice/invoice_config_model.dart';
import '../services/hive/invoice_service.dart';

class SaleProvider extends ChangeNotifier {
  List<Sale> _sales = [];
  List<Sale> _filteredSales = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<Sale> get sales => _filteredSales;
  bool get isLoading => _isLoading;

  SaleProvider() {
    loadSales();
  }

  Future<void> loadSales() async {
    _isLoading = true;
    notifyListeners();

    _sales = await SaleHiveService.getAllSales();
    _applyFilter();

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredSales = List.from(_sales);
    } else {
      _filteredSales = _sales.where((sale) {
        final query = _searchQuery.toLowerCase();
        return sale.id.toLowerCase().contains(query) ||
            sale.customerName.toLowerCase().contains(query);
      }).toList();
    }
  }

  Future<String> getNextInvoiceId() async {
    final config = await InvoiceHiveService.getInvoiceConfig() ?? 
        InvoiceConfig(prefix: "INV-", startingNumber: 1001, footerText: "", showLogo: true);
    
    // We can count existing sales to determine the next number, 
    // but usually, it's better to keep track of the last number in config.
    // For now, let's use the starting number + current number of sales.
    final nextNumber = config.startingNumber + _sales.length;
    return "${config.prefix}$nextNumber";
  }

  Future<void> addSale(Sale sale) async {
    await SaleHiveService.saveSale(sale);
    await loadSales();
  }

  Future<void> refundSale(Sale sale) async {
    await updateSaleStatus(sale, 'Refunded');
  }
  
  Future<void> updateSaleStatus(Sale sale, String status) async {
    sale.status = status;
    await sale.save();
    notifyListeners();
  }
}
