import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/models/business/business_model.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/services/hive/business_service.dart';
import 'package:shelfo/services/image_service.dart';

class BusinessProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  
  Currency _selectedCurrency = Currency.inr;
  Currency get selectedCurrency => _selectedCurrency;

  String? _logoPath;
  String? get logoPath => _logoPath;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  BusinessProvider() {
    _loadBusiness();
  }

  Future<void> _loadBusiness() async {
    _isLoading = true;
    notifyListeners();

    final business = await BusinessHiveService.getBusiness();

    if (business != null) {
      nameController.text = business.name;
      phoneController.text = business.phoneNumber;
      addressController.text = business.address;
      _selectedCurrency = business.currency;
      _logoPath = business.logoPath;
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCurrency(Currency currency) {
    _selectedCurrency = currency;
    notifyListeners();
  }

  Future<void> pickLogo(ImageSource source) async {
    final File? pickedFile = await ImageService.pickImage(source);
    if (pickedFile != null) {
      final String? savedPath = await ImageService.saveImageToLocalDirectory(pickedFile);
      if (savedPath != null) {
        if (_logoPath != null && !_logoPath!.startsWith('assets/')) {
          await ImageService.deleteImage(_logoPath);
        }
        _logoPath = savedPath;
        notifyListeners();
      }
    }
  }

  void removeLogo() {
    if (_logoPath != null && !_logoPath!.startsWith('assets/')) {
      ImageService.deleteImage(_logoPath);
      _logoPath = null;
      notifyListeners();
    }
  }

  Future<void> saveBusiness() async {
    final business = Business(
      name: nameController.text.trim(),
      phoneNumber: phoneController.text.trim(),
      address: addressController.text.trim(),
      currency: _selectedCurrency,
      logoPath: _logoPath,
    );

    await BusinessHiveService.saveBusiness(business);
    
    debugPrint("Saved Business: ${business.name}");
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
