import 'package:flutter/material.dart';
import '../models/customer/customer_model.dart';

class CustomerFormProvider extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController creditLimitController;
  CustomerType selectedType = CustomerType.business;

  CustomerFormProvider(Customer? customer) {
    nameController = TextEditingController(text: customer?.name);
    emailController = TextEditingController(text: customer?.email);
    phoneController = TextEditingController(text: customer?.phone);
    addressController = TextEditingController(text: customer?.address);
    creditLimitController = TextEditingController(
      text: customer?.creditLimit.toString() ?? "10000",
    );
    selectedType = customer?.type ?? CustomerType.business;
  }

  void setType(CustomerType type) {
    selectedType = type;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    creditLimitController.dispose();
    super.dispose();
  }
}
