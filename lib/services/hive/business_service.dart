import 'package:hive_ce/hive_ce.dart';
import 'package:shelfo/models/business/business_model.dart';
import 'package:shelfo/services/hive/hive_service.dart';

class BusinessHiveService {
  static const String _businessKey = 'businessData';

  static Future<Box<Business>> _getBox() => HiveService.getBox<Business>(HiveService.businessBox);

  static Future<Business?> getBusiness() async {
    final box = await _getBox();
    return box.get(_businessKey);
  }

  static Future<void> saveBusiness(Business business) async {
    final box = await _getBox();
    await box.put(_businessKey, business);
  }
}
