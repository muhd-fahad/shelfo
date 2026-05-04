import 'package:flutter/material.dart';
import 'package:shelfo/models/invoice/invoice_config_model.dart';
import 'package:shelfo/services/hive/invoice_service.dart';

class InvoiceProvider extends ChangeNotifier {
  final TextEditingController prefixController = TextEditingController(text: "INV-");
  final TextEditingController startingNumberController = TextEditingController(text: "1001");
  final TextEditingController footerTextController = TextEditingController(text: "Thank you for your business!");
  
  bool _showLogo = true;
  bool get showLogo => _showLogo;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  InvoiceProvider() {
    _loadInvoiceConfig();
  }

  Future<void> _loadInvoiceConfig() async {
    _isLoading = true;
    notifyListeners();

    final config = await InvoiceHiveService.getInvoiceConfig();

    if (config != null) {
      prefixController.text = config.prefix;
      startingNumberController.text = config.startingNumber.toString();
      footerTextController.text = config.footerText;
      _showLogo = config.showLogo;
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleShowLogo(bool value) {
    _showLogo = value;
    notifyListeners();
  }

  Future<void> saveInvoiceConfig() async {
    final config = InvoiceConfig(
      prefix: prefixController.text.trim(),
      startingNumber: int.tryParse(startingNumberController.text) ?? 1000,
      footerText: footerTextController.text.trim(),
      showLogo: _showLogo,
    );

    await InvoiceHiveService.saveInvoiceConfig(config);
    
    debugPrint("Saved Invoice Config");
    notifyListeners();
  }

  @override
  void dispose() {
    prefixController.dispose();
    startingNumberController.dispose();
    footerTextController.dispose();
    super.dispose();
  }
}
