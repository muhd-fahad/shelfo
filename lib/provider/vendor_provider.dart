import 'package:flutter/material.dart';
import '../models/vendor/vendor_model.dart';
import '../services/hive/hive_service.dart';
import 'package:hive_ce/hive.dart';

class VendorProvider extends ChangeNotifier {
  List<Vendor> _vendors = [];
  List<Vendor> _filteredVendors = [];
  String _searchQuery = '';

  List<Vendor> get vendors => _filteredVendors;

  VendorProvider() {
    _loadVendors();
  }

  Future<void> _loadVendors() async {
    final box = await HiveService.getBox<Vendor>(HiveService.vendorsBox);
    _vendors = box.values.toList();
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    if (_searchQuery.isEmpty) {
      _filteredVendors = _vendors;
    } else {
      _filteredVendors = _vendors
          .where((v) =>
              v.companyName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (v.contactPerson?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();
    }
  }

  Future<void> addVendor(Vendor vendor) async {
    final box = await HiveService.getBox<Vendor>(HiveService.vendorsBox);
    await box.add(vendor);
    _vendors.add(vendor);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateVendor(Vendor vendor) async {
    await vendor.save();
    final index = _vendors.indexWhere((v) => v.id == vendor.id);
    if (index != -1) {
      _vendors[index] = vendor;
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> deleteVendor(Vendor vendor) async {
    await vendor.delete();
    _vendors.removeWhere((v) => v.id == vendor.id);
    _applyFilters();
    notifyListeners();
  }
}
