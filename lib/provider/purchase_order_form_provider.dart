import 'package:flutter/material.dart';
import '../models/purchase/purchase_order_model.dart';
import '../models/purchase/purchase_item_model.dart';
import '../models/vendor/vendor_model.dart';
import '../models/product/product_model.dart';

class PurchaseOrderFormProvider extends ChangeNotifier {
  final PurchaseOrder? originalOrder;

  Vendor? selectedVendor;
  DateTime? expectedDate;
  final TextEditingController notesController = TextEditingController();
  
  Product? selectedProduct;
  final TextEditingController quantityController = TextEditingController(text: "1");
  final TextEditingController costController = TextEditingController(text: "0");
  
  List<PurchaseItem> items = [];

  PurchaseOrderFormProvider({this.originalOrder, List<Vendor> vendors = const []}) {
    if (originalOrder != null) {
      expectedDate = originalOrder!.expectedDate;
      notesController.text = originalOrder!.notes ?? "";
      items = List.from(originalOrder!.items);
      if (vendors.isNotEmpty) {
        selectedVendor = vendors.firstWhere(
          (v) => v.id == originalOrder!.vendorId,
          orElse: () => vendors.firstWhere((v) => v.companyName == originalOrder!.vendorName),
        );
      }
    }
  }

  bool get isEditing => originalOrder != null;

  void setVendor(Vendor? vendor) {
    selectedVendor = vendor;
    notifyListeners();
  }

  void setExpectedDate(DateTime? date) {
    expectedDate = date;
    notifyListeners();
  }

  void setProduct(Product? product) {
    selectedProduct = product;
    if (product != null) {
      costController.text = product.costPrice.toString();
    }
    notifyListeners();
  }

  void addItem() {
    if (selectedProduct != null) {
      final quantity = int.tryParse(quantityController.text) ?? 1;
      final cost = double.tryParse(costController.text) ?? 0.0;
      
      final index = items.indexWhere((item) => item.productId == selectedProduct!.id);
      if (index != -1) {
        final existing = items[index];
        items[index] = PurchaseItem(
          productId: selectedProduct!.id,
          productName: selectedProduct!.name,
          quantity: existing.quantity + quantity,
          costPrice: cost,
          total: (existing.quantity + quantity) * cost,
        );
      } else {
        items.add(PurchaseItem(
          productId: selectedProduct!.id,
          productName: selectedProduct!.name,
          quantity: quantity,
          costPrice: cost,
          total: quantity * cost,
        ));
      }
      
      selectedProduct = null;
      quantityController.text = "1";
      costController.text = "0";
      notifyListeners();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal;

  @override
  void dispose() {
    notesController.dispose();
    quantityController.dispose();
    costController.dispose();
    super.dispose();
  }
}
