import 'package:flutter/material.dart';

import '../../models/policy/policy_model.dart';

class PolicyFormProvider extends ChangeNotifier {
  final nameController = TextEditingController();
  final durationController = TextEditingController(text: '30');
  final descriptionController = TextEditingController();
  List<TextEditingController> conditionControllers = [TextEditingController()];
  
  PolicyType selectedType = PolicyType.warranty;
  bool isActive = true;

  void init(Policy? policy) {
    if (policy != null) {
      nameController.text = policy.name;
      durationController.text = policy.durationDays.toString();
      descriptionController.text = policy.description;
      selectedType = policy.type;
      isActive = policy.isActive;
      conditionControllers = policy.conditions
          .map((c) => TextEditingController(text: c))
          .toList();
      if (conditionControllers.isEmpty) {
        conditionControllers.add(TextEditingController());
      }
    } else {
      nameController.clear();
      durationController.text = '30';
      descriptionController.clear();
      selectedType = PolicyType.warranty;
      isActive = true;
      conditionControllers = [TextEditingController()];
    }
    notifyListeners();
  }

  void setType(PolicyType type) {
    selectedType = type;
    notifyListeners();
  }

  void toggleActive(bool value) {
    isActive = value;
    notifyListeners();
  }

  void addCondition() {
    conditionControllers.add(TextEditingController());
    notifyListeners();
  }

  void removeCondition(int index) {
    if (conditionControllers.length > 1) {
      conditionControllers[index].dispose();
      conditionControllers.removeAt(index);
      notifyListeners();
    } else {
      conditionControllers[0].clear();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    descriptionController.dispose();
    for (var controller in conditionControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
