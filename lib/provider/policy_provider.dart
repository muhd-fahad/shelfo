import 'package:flutter/material.dart';
import '../models/policy/policy_model.dart';
import '../services/hive/policy_service.dart';

class PolicyProvider extends ChangeNotifier {
  List<Policy> _policies = [];
  bool _isLoading = false;

  List<Policy> get policies => _policies;
  bool get isLoading => _isLoading;

  PolicyProvider() {
    loadPolicies();
  }

  Future<void> loadPolicies() async {
    _isLoading = true;
    notifyListeners();

    _policies = await PolicyHiveService.getPolicies();

    if (_policies.isEmpty) {
      final now = DateTime.now();
      final defaultPolicies = [
        Policy(
          id: '1',
          name: "Standard Product Warranty",
          type: PolicyType.warranty,
          durationDays: 365,
          description: "Covers manufacturing defects and hardware failures for standard products.",
          conditions: [
            "Valid for 1 year from purchase date.",
            "Does not cover physical damage, liquid damage, or unauthorized modifications.",
          ],
          createdAt: now,
        ),
        Policy(
          id: '2',
          name: "Extended Warranty - Electronics",
          type: PolicyType.warranty,
          durationDays: 730,
          description: "Extended coverage for electronics including laptops, monitors, and audio equipment.",
          conditions: [
            "Valid for 2 years from purchase.",
            "Covers parts and labor.",
            "Original receipt required.",
          ],
          createdAt: now,
        ),
        Policy(
          id: '3',
          name: "Standard Return Policy",
          type: PolicyType.returnPolicy,
          durationDays: 7,
          description: "Customers may return unused items within the return window.",
          conditions: [
            "Items must be in original packaging, unused, and with complete accessories.",
            "Receipt required.",
            "Return window starts from date of purchase.",
          ],
          createdAt: now,
        ),
        Policy(
          id: '4',
          name: "Extended Return - Business Accounts",
          type: PolicyType.returnPolicy,
          durationDays: 30,
          description: "Extended return window for registered business customers.",
          conditions: [
            "Applicable to business account holders only.",
            "Items must be in resalable condition.",
            "Return shipping costs may apply.",
          ],
          isActive: false,
          createdAt: now,
        ),
        Policy(
          id: '5',
          name: "Repair Service Guarantee",
          type: PolicyType.service,
          durationDays: 90,
          description: "All repair services are guaranteed for 90 days after completion.",
          conditions: [
            "Covers the same issue repaired.",
            "Does not cover new damage or unrelated issues.",
            "Warranty void if seal is broken.",
          ],
          createdAt: now,
        ),
        Policy(
          id: '6',
          name: "Premium Service Plan",
          type: PolicyType.service,
          durationDays: 365,
          description: "Annual service plan with priority repair, free diagnostics, and discounted labor.",
          conditions: [
            "Annual subscription.",
            "Includes 2 free diagnostics, 20% off labor costs, priority support.",
            "Non-transferable.",
          ],
          createdAt: now,
        ),
      ];

      for (var policy in defaultPolicies) {
        await PolicyHiveService.addPolicy(policy);
      }
      _policies = await PolicyHiveService.getPolicies();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPolicy(Policy policy) async {
    await PolicyHiveService.addPolicy(policy);
    await loadPolicies();
  }

  Future<void> updatePolicy(Policy policy) async {
    await PolicyHiveService.updatePolicy(policy);
    await loadPolicies();
  }

  Future<void> deletePolicy(String id) async {
    await PolicyHiveService.deletePolicy(id);
    await loadPolicies();
  }

  List<Policy> getPoliciesByType(PolicyType type) {
    return _policies.where((p) => p.type == type).toList();
  }
}
