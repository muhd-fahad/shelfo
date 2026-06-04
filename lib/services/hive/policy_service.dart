import 'package:hive_ce/hive.dart';
import '../../models/policy/policy_model.dart';

class PolicyHiveService {
  static const String _boxName = 'policies';

  static Future<Box<Policy>> get _box async => await Hive.openBox<Policy>(_boxName);

  static Future<void> addPolicy(Policy policy) async {
    final box = await _box;
    await box.put(policy.id, policy);
  }

  static Future<List<Policy>> getPolicies() async {
    final box = await _box;
    return box.values.toList();
  }

  static Future<void> updatePolicy(Policy policy) async {
    final box = await _box;
    await box.put(policy.id, policy);
  }

  static Future<void> deletePolicy(String id) async {
    final box = await _box;
    await box.delete(id);
  }
}
