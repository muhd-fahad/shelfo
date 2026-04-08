import 'package:flutter/material.dart';
import 'package:shelfo/models/currency.dart';

class BusinessProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController(text: "Urban Brew Cafe");
  final TextEditingController phoneController = TextEditingController(text: "+1 (555) 123-4567");
  final TextEditingController addressController = TextEditingController(text: "123 Market Street, San Francisco, CA 94103");
  
  Currency _selectedCurrency = Currency.usd;
  Currency get selectedCurrency => _selectedCurrency;

  void setCurrency(Currency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  void saveBusiness() {

    debugPrint("Saving Business: ${nameController.text}, ${selectedCurrency.code}");
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
