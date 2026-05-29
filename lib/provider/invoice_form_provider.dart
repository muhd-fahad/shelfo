import 'package:flutter/material.dart';
import '../models/sale/sale_model.dart';
import '../models/sale/sale_item_model.dart';
import '../models/product/product_model.dart';
import '../models/customer/customer_model.dart';

class InvoiceFormProvider extends ChangeNotifier {
  final Sale? originalInvoice;
  final double taxRate;
  final bool isTaxEnabled;
  final String taxLabel;

  Customer? selectedCustomer;
  String paymentMethod = 'Cash';
  final TextEditingController notesController = TextEditingController();
  
  Product? selectedProduct;
  final TextEditingController quantityController = TextEditingController(text: "1");
  
  List<SaleItem> items = [];

  InvoiceFormProvider(this.originalInvoice, {
    required this.taxRate,
    required this.isTaxEnabled,
    required this.taxLabel,
    List<Customer> allCustomers = const [],
  }) {
    if (originalInvoice != null) {
      if (allCustomers.isNotEmpty) {
        selectedCustomer = allCustomers.firstWhere(
          (c) => c.name == originalInvoice!.customerName,
          orElse: () => Customer(
            id: '',
            name: originalInvoice!.customerName,
            type: CustomerType.individual,
            creditLimit: 0,
            createdAt: DateTime.now(),
          ),
        );
      }
      paymentMethod = originalInvoice!.paymentMethod;
      notesController.text = originalInvoice!.notes ?? "";
      items = List.from(originalInvoice!.items);
    }
  }

  bool get isEditing => originalInvoice != null;

  void setCustomer(Customer? customer) {
    selectedCustomer = customer;
    notifyListeners();
  }

  void setPaymentMethod(String method) {
    paymentMethod = method;
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
