import 'package:flutter/material.dart';

import '../../models/customer/customer_model.dart';
import '../../models/product/product_model.dart';
import '../../models/sale/sale_item_model.dart';
import '../../models/sale/sale_model.dart';
import '../../models/tax/tax_pricing_mode.dart';

class InvoiceFormProvider extends ChangeNotifier {
  final Sale? originalInvoice;
  final double taxRate;
  final bool isTaxEnabled;
  final String taxLabel;
  final TaxPricingMode pricingMode;

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
    required this.pricingMode,
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

  double get _baseSubtotal => items.fold(0, (sum, item) => sum + item.total);

  double get subtotal {
    if (!isTaxEnabled) return _baseSubtotal;
    if (pricingMode == TaxPricingMode.inclusive) {
      return _baseSubtotal - taxAmount;
    }
    return _baseSubtotal;
  }
  
  double get taxAmount {
    if (!isTaxEnabled) return 0.0;
    
    if (pricingMode == TaxPricingMode.inclusive) {
      // _baseSubtotal already includes tax
      return _baseSubtotal - (_baseSubtotal / (1 + (taxRate / 100)));
    } else {
      // Tax is added on top of _baseSubtotal
      return _baseSubtotal * (taxRate / 100);
    }
  }

  double get total {
    if (!isTaxEnabled) return _baseSubtotal;
    
    if (pricingMode == TaxPricingMode.inclusive) {
      return _baseSubtotal;
    } else {
      return _baseSubtotal + taxAmount;
    }
  }

  @override
  void dispose() {
    notesController.dispose();
    quantityController.dispose();
    super.dispose();
  }
}
