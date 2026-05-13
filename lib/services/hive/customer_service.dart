import 'package:hive_ce/hive_ce.dart';
import '../../models/customer/customer_model.dart';
import 'hive_service.dart';

class CustomerHiveService {
  static Future<Box<Customer>> _getBox() async {
    return HiveService.getBox<Customer>(HiveService.customersBox);
  }

  static Future<List<Customer>> getAllCustomers() async {
    final box = await _getBox();
    return box.values.toList();
  }

  static Future<void> saveCustomer(Customer customer) async {
    final box = await _getBox();
    await box.put(customer.id, customer);
  }

  static Future<void> deleteCustomer(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
