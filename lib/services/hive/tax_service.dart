import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/tax/tax_config_model.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class TaxHiveService {
  static const String _taxKey = 'taxData';

  static Future<Box<TaxConfig>> _getBox() => HiveService.getBox<TaxConfig>(HiveService.taxBox);

  static Future<TaxConfig?> getTaxConfig() async {
    final box = await _getBox();
    return box.get(_taxKey);
  }

  static Future<void> saveTaxConfig(TaxConfig config) async {
    final box = await _getBox();
    await box.put(_taxKey, config);
  }
}
