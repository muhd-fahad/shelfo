import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/invoice/invoice_config_model.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class InvoiceHiveService {
  static const String _invoiceKey = 'invoiceData';

  static Future<Box<InvoiceConfig>> _getBox() async {
    return HiveService.getBox<InvoiceConfig>(HiveService.invoiceBox);
  }

  static Future<InvoiceConfig?> getInvoiceConfig() async {
    final box = await _getBox();
    return box.get(_invoiceKey);
  }

  static Future<void> saveInvoiceConfig(InvoiceConfig config) async {
    final box = await _getBox();
    await box.put(_invoiceKey, config);
  }
}
