import 'package:flutter/material.dart';

import '../../models/invoice/invoice_config_model.dart';
import '../../models/sale/sale_model.dart';
import '../../services/hive/invoice_service.dart';
import '../../services/hive/sale_service.dart';
import '../inventory/product_provider.dart';

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

  Future<void> addSale(Sale sale, {ProductProvider? productProvider}) async {
    await SaleHiveService.saveSale(sale);
    
    if (productProvider != null) {
      for (var item in sale.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: false);
        } catch (e) {
          debugPrint("Product not found for stock update: ${item.productId}");
        }
      }
    }
    
    await loadSales();
  }

  Future<void> updateSale(Sale sale) async {
    await SaleHiveService.updateSale(sale);
    await loadSales();
  }

  Future<void> deleteSale(Sale sale, {ProductProvider? productProvider}) async {
    if (productProvider != null && sale.status != 'Refunded' && sale.status != 'Cancelled') {
      // Return stock when deleting an active sale
      for (var item in sale.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: true);
        } catch (e) {
          debugPrint("Product not found for stock return: ${item.productId}");
        }
      }
    }
    await SaleHiveService.deleteSale(sale);
    await loadSales();
  }

  Future<void> refundSale(Sale sale, {ProductProvider? productProvider}) async {
    await updateSaleStatus(sale, 'Refunded');
    
    if (productProvider != null) {
      for (var item in sale.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: true);
        } catch (e) {
          debugPrint("Product not found for stock update: ${item.productId}");
        }
      }
    }
  }
  
  Future<void> updateSaleStatus(Sale sale, String status) async {
    sale.status = status;
    await sale.save();
    notifyListeners();
  }
}
