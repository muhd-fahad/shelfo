import 'package:flutter/material.dart';
import '../models/product/product_model.dart';
import '../models/tax/tax_pricing_mode.dart';
import 'product_provider.dart';
import 'tax_provider.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  TaxProvider? _taxProvider;

  // Checkout State
  String _selectedPaymentMethod = 'Cash';
  final TextEditingController amountTenderedController = TextEditingController();
  double _change = 0.0;
  String _selectedCustomer = 'Walk-in Customer';

  List<CartItem> get items => _items;

  CartProvider() {
    amountTenderedController.addListener(_calculateChange);
  }

  void _calculateChange() {
    final tendered = double.tryParse(amountTenderedController.text) ?? 0.0;
    _change = tendered > 0 ? tendered - total : 0.0;
    notifyListeners();
  }

  String get selectedPaymentMethod => _selectedPaymentMethod;
  double get change => _change;
  String get selectedCustomer => _selectedCustomer;

  void setPaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void setCustomer(String customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  void resetCheckout() {
    _selectedPaymentMethod = 'Cash';
    amountTenderedController.clear();
    _change = 0.0;
    _selectedCustomer = 'Walk-in Customer';
    notifyListeners();
  }

  void updateTaxProvider(TaxProvider taxProvider) {
    _taxProvider = taxProvider;
    notifyListeners();
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  
  double get taxAmount {
    if (_taxProvider == null || !_taxProvider!.isTaxEnabled) return 0.0;
    
    final rate = double.tryParse(_taxProvider!.taxRateController.text) ?? 0.0;
    
    if (_taxProvider!.pricingMode == TaxPricingMode.inclusive) {
      // Subtotal already includes tax
      return subtotal - (subtotal / (1 + (rate / 100)));
    } else {
      // Tax is added on top of subtotal
      return subtotal * (rate / 100);
    }
  }

  double get total {
    if (_taxProvider == null || !_taxProvider!.isTaxEnabled) return subtotal;
    
    if (_taxProvider!.pricingMode == TaxPricingMode.inclusive) {
      return subtotal;
    } else {
      return subtotal + taxAmount;
    }
  }

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  /// Adds a product to the cart.
  /// Returns 0 if item was added as new, 1 if quantity was updated, -1 if out of stock.
  int addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    
    // Check stock for stocked/serialized products
    final bool isStockLimited = product.productType == ProductType.stocked || 
                               product.productType == ProductType.serialized;

    if (index != -1) {
      if (isStockLimited && _items[index].quantity >= product.stockQuantity) {
        return -1; // Out of stock
      }
      _items[index].quantity++;
      notifyListeners();
      return 1; // Updated
    } else {
      if (isStockLimited && product.stockQuantity <= 0) {
        return -1; // Out of stock
      }
      _items.add(CartItem(product: product));
      notifyListeners();
      return 0; // New item
    }
  }

  void removeFromCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<void> completeSale(ProductProvider productProvider) async {
    for (var item in _items) {
      await productProvider.adjustStock(item.product, item.quantity, isAddition: false);
    }
    clearCart();
    resetCheckout();
  }

  @override
  void dispose() {
    amountTenderedController.dispose();
    super.dispose();
  }
}
