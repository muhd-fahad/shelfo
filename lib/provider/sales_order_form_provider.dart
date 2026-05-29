import 'package:flutter/material.dart';
import '../models/sale/sales_order_model.dart';
import '../models/sale/sale_item_model.dart';
import '../models/product/product_model.dart';

import '../models/customer/customer_model.dart';

class SalesOrderFormProvider extends ChangeNotifier {
  final SalesOrder? originalOrder;
  final double taxRate;
  final bool isTaxEnabled;
  final String taxLabel;

  Customer? selectedCustomer;
  SalesOrderStatus selectedStatus = SalesOrderStatus.draft;
  final TextEditingController notesController = TextEditingController();
  
  Product? selectedProduct;
  final TextEditingController quantityController = TextEditingController(text: "1");
  
  List<SaleItem> items = [];

  SalesOrderFormProvider(this.originalOrder, {
    required this.taxRate,
    required this.isTaxEnabled,
    required this.taxLabel,
    List<Customer> allCustomers = const [],
  }) {
    if (originalOrder != null) {
      if (allCustomers.isNotEmpty) {
        selectedCustomer = allCustomers.firstWhere(
          (c) => c.name == originalOrder!.customerName,
          orElse: () => Customer(
            id: '',
            name: originalOrder!.customerName,
            type: CustomerType.individual,
            creditLimit: 0,
            createdAt: DateTime.now(),
          ),
        );
      }
      selectedStatus = originalOrder!.status;
      notesController.text = originalOrder!.notes ?? "";
      items = List.from(originalOrder!.items);
    }
  }

  bool get isEditing => originalOrder != null;

  void setCustomer(Customer? customer) {
    selectedCustomer = customer;
    notifyListeners();
  }

  void setStatus(SalesOrderStatus status) {
    selectedStatus = status;
    notifyListeners();
  }

  void setProduct(Product? product) {
    selectedProduct = product;
    notifyListeners();
  }

  void addItem() {
    if (selectedProduct != null) {
      final quantity = int.tryParse(quantityController.text) ?? 1;
      final newItem = SaleItem(
        productId: selectedProduct!.id,
        productName: selectedProduct!.name,
        quantity: quantity,
        price: selectedProduct!.price,
        total: selectedProduct!.price * quantity,
      );
      items.add(newItem);
      selectedProduct = null;
      quantityController.text = "1";
      notifyListeners();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get taxAmount => isTaxEnabled ? (subtotal * (taxRate / 100)) : 0.0;
  double get total => subtotal + taxAmount;

  @override
  void dispose() {
    notesController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
