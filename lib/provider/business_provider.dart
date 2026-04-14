import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/business/business_model.dart';
import 'package:shelfo/models/currency/currency.dart';

class BusinessProvider extends ChangeNotifier {
  static const String _boxName = 'businessBox';
  static const String _businessKey = 'businessData';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  Currency _selectedCurrency = Currency.inr;
  Currency get selectedCurrency => _selectedCurrency;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  BusinessProvider() {
    _loadBusiness();
  }

  Future<void> _loadBusiness() async {
    _isLoading = true;
    notifyListeners();

    final box = await Hive.openBox<Business>(_boxName);
    final business = box.get(_businessKey);

    if (business != null) {
      nameController.text = business.name;
      phoneController.text = business.phoneNumber;
      addressController.text = business.address;
      _selectedCurrency = business.currency;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCurrency(Currency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  Future<void> saveBusiness() async {
    final business = Business(
      name: nameController.text,
      phoneNumber: phoneController.text,
      address: addressController.text,
      currency: _selectedCurrency,
    );

    final box = await Hive.openBox<Business>(_boxName);
    await box.put(_businessKey, business);
    
    debugPrint("Saved Business to Hive: ${business.name}");
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
