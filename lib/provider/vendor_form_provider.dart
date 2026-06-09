import 'package:flutter/material.dart';
import '../models/vendor/vendor_model.dart';

class VendorFormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Vendor? originalVendor;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedCategory;

  VendorFormProvider({this.originalVendor}) {
    if (originalVendor != null) {
      nameController.text = originalVendor!.companyName;
      contactController.text = originalVendor!.contactPerson ?? '';
      emailController.text = originalVendor!.email ?? '';
      phoneController.text = originalVendor!.phone ?? '';
      addressController.text = originalVendor!.address ?? '';
      selectedCategory = originalVendor!.category;
    }
  }

  void setCategory(String? category) {
    selectedCategory = category;
    notifyListeners();
  }

  bool get isEditing => originalVendor != null;

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }
}
