import 'package:flutter/material.dart';
import '../../models/purchase/purchase_order_model.dart';
import '../../services/hive/hive_service.dart';
import '../inventory/product_provider.dart';
import 'purchase_order_form_provider.dart';

class PurchaseOrderProvider extends ChangeNotifier {
  List<PurchaseOrder> _orders = [];
  List<PurchaseOrder> _filteredOrders = [];
  String _searchQuery = '';
  PurchaseOrderStatus? _statusFilter;

  List<PurchaseOrder> get orders => _filteredOrders;
  List<PurchaseOrder> get allOrders => _orders;
  PurchaseOrderStatus? get statusFilter => _statusFilter;

  PurchaseOrderProvider() {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final box = await HiveService.getBox<PurchaseOrder>(HiveService.purchaseOrdersBox);
    _orders = box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void setStatusFilter(PurchaseOrderStatus? status) {
    _statusFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredOrders = _orders.where((order) {
      final matchesSearch = order.vendorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.id.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _statusFilter == null || order.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  String generateNextPoId() {
    final year = DateTime.now().year;
    final count = _orders.length + 1;
    return "PO-$year-${count.toString().padLeft(3, '0')}";
  }

  Future<void> addOrderFromForm(PurchaseOrderFormProvider form, {ProductProvider? productProvider}) async {
    if (form.selectedVendor == null || form.items.isEmpty) return;

    final newOrder = PurchaseOrder(
      id: generateNextPoId(),
      date: DateTime.now(),
      expectedDate: form.expectedDate,
      vendorId: form.selectedVendor!.id,
      vendorName: form.selectedVendor!.companyName,
      items: List.from(form.items),
      subtotal: form.subtotal,
      taxAmount: form.taxAmount,
      total: form.total,
      status: PurchaseOrderStatus.ordered,
      notes: form.notesController.text,
    );

    final box = await HiveService.getBox<PurchaseOrder>(HiveService.purchaseOrdersBox);
    await box.add(newOrder);

    // Reflect stock if it's considered "happened" (per user request)
    // Most users might expect stock to increase when PO is created if they want "immediate reflection"
    // However, if we want to be more accurate, we should probably only do this if status is 'received'
    // But since the user asked for it to happen when order "happened", I'll add logic here or in status update.
    // Given the phrasing, I'll add it to status update primarily, but also check if status is already 'received'
    if (newOrder.status == PurchaseOrderStatus.received && productProvider != null) {
      for (var item in newOrder.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: true);
        } catch (e) {
          debugPrint("Product not found for stock update: ${item.productId}");
        }
      }
    }

    _orders.insert(0, newOrder);
    _applyFilters();
    notifyListeners();
  }

  Future<void> updateOrderFromForm(PurchaseOrderFormProvider form) async {
    if (form.originalOrder == null || form.selectedVendor == null) return;

    final updatedOrder = form.originalOrder!.copyWith(
      expectedDate: form.expectedDate,
      vendorId: form.selectedVendor!.id,
      vendorName: form.selectedVendor!.companyName,
      items: List.from(form.items),
      subtotal: form.subtotal,
      taxAmount: form.taxAmount,
      total: form.total,
      notes: form.notesController.text,
    );

    await updatedOrder.save();
    
    final index = _orders.indexWhere((o) => o.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(PurchaseOrder order, PurchaseOrderStatus status, {ProductProvider? productProvider}) async {
    order.status = status;
    await order.save();

    if (status == PurchaseOrderStatus.received && productProvider != null) {
      for (var item in order.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: true);
        } catch (e) {
          debugPrint("Product not found for stock update: ${item.productId}");
        }
      }
    }

    _applyFilters();
    notifyListeners();
  }

  Future<void> deleteOrder(PurchaseOrder order, {ProductProvider? productProvider}) async {
    if (productProvider != null && order.status == PurchaseOrderStatus.received) {
      // Reduce stock if it was already increased
      for (var item in order.items) {
        try {
          final product = productProvider.products.firstWhere((p) => p.id == item.productId);
          await productProvider.adjustStock(product, item.quantity, isAddition: false);
        } catch (e) {
          debugPrint("Product not found for stock correction: ${item.productId}");
        }
      }
    }
    await order.delete();
    _orders.removeWhere((o) => o.id == order.id);
    _applyFilters();
    notifyListeners();
  }
}
