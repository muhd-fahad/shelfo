import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/tax/tax_config_model.dart';
import 'package:shelfo/models/tax/tax_pricing_mode.dart';

class TaxProvider extends ChangeNotifier {
  static const String _boxName = 'taxBox';
  static const String _taxKey = 'taxData';

  final TextEditingController taxRateController = TextEditingController(text: "8.5");
  final TextEditingController taxLabelController = TextEditingController(text: "Sales Tax");
  
  bool _isTaxEnabled = true;
  bool get isTaxEnabled => _isTaxEnabled;

  TaxPricingMode _pricingMode = TaxPricingMode.exclusive;
  TaxPricingMode get pricingMode => _pricingMode;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  TaxProvider() {
    _loadTaxConfig();
  }

  Future<void> _loadTaxConfig() async {
    _isLoading = true;
    notifyListeners();

    final box = await Hive.openBox<TaxConfig>(_boxName);
    final config = box.get(_taxKey);

    if (config != null) {
      _isTaxEnabled = config.isTaxEnabled;
      taxRateController.text = config.defaultTaxRate.toString();
      taxLabelController.text = config.taxLabel;
      _pricingMode = config.pricingMode;
    }

    _isLoading = false;
    notifyListeners();
  }

  void toggleTaxEnabled(bool value) {
    _isTaxEnabled = value;
    notifyListeners();
  }

  void setPricingMode(TaxPricingMode mode) {
    _pricingMode = mode;
    notifyListeners();
  }

  Future<void> saveTaxConfig() async {
    final config = TaxConfig(
      isTaxEnabled: _isTaxEnabled,
      defaultTaxRate: double.tryParse(taxRateController.text) ?? 0.0,
      taxLabel: taxLabelController.text,
      pricingMode: _pricingMode,
    );

    final box = await Hive.openBox<TaxConfig>(_boxName);
    await box.put(_taxKey, config);
    
    debugPrint("Saved Tax Config to Hive");
    notifyListeners();
  }

  @override
  void dispose() {
    taxRateController.dispose();
    taxLabelController.dispose();
    super.dispose();
  }
}
