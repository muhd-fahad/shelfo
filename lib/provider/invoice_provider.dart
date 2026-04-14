import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/invoice/invoice_config_model.dart';

class InvoiceProvider extends ChangeNotifier {
  static const String _boxName = 'invoiceBox';
  static const String _invoiceKey = 'invoiceData';

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

    final box = await Hive.openBox<InvoiceConfig>(_boxName);
    final config = box.get(_invoiceKey);

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
      prefix: prefixController.text,
      startingNumber: int.tryParse(startingNumberController.text) ?? 1000,
      footerText: footerTextController.text,
      showLogo: _showLogo,
    );

    final box = await Hive.openBox<InvoiceConfig>(_boxName);
    await box.put(_invoiceKey, config);
    
    debugPrint("Saved Invoice Config to Hive");
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
