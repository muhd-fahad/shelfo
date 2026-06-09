import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/vendor/vendor_model.dart';
import '../../provider/vendor_provider.dart';
import '../../provider/vendor_form_provider.dart';
import '../../widgets/sfo_common/sfo_background.dart';
import '../../widgets/sfo_common/sfo_header.dart';
import '../../widgets/sfo_common/sfo_input_field.dart';
import '../../widgets/sfo_common/sfo_button.dart';
import '../../widgets/sfo_common/sfo_dropdown.dart';
import '../../widgets/sfo_common/sfo_card.dart';

class AddVendorScreen extends StatelessWidget {
  final Vendor? vendor;
  const AddVendorScreen({super.key, this.vendor});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VendorFormProvider(originalVendor: vendor),
      child: const _AddVendorContent(),
    );
  }
}

class _AddVendorContent extends StatelessWidget {
  const _AddVendorContent();

  void _save(BuildContext context, VendorFormProvider formProvider) {
    if (formProvider.formKey.currentState?.validate() ?? false) {
      final vendorProvider = context.read<VendorProvider>();
      
      if (!formProvider.isEditing) {
        final newVendor = Vendor(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          companyName: formProvider.nameController.text,
          contactPerson: formProvider.contactController.text,
          email: formProvider.emailController.text,
          phone: formProvider.phoneController.text,
          address: formProvider.addressController.text,
          category: formProvider.selectedCategory,
          createdAt: DateTime.now(),
        );
        vendorProvider.addVendor(newVendor);
      } else {
        final updatedVendor = formProvider.originalVendor!.copyWith(
          companyName: formProvider.nameController.text,
          contactPerson: formProvider.contactController.text,
          email: formProvider.emailController.text,
          phone: formProvider.phoneController.text,
          address: formProvider.addressController.text,
          category: formProvider.selectedCategory,
        );
        vendorProvider.updateVendor(updatedVendor);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<VendorFormProvider>();

    return Scaffold(
      appBar: SFOHeader(title: formProvider.isEditing ? "Edit Vendor" : "Add Vendor"),
      body: SFOBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: formProvider.formKey,
            child: SFOCard(
              padding: EdgeInsets.all(16.r),
              children: [
                SFOInputField(
                  label: "Company Name",
                  isRequired: true,
                  controller: formProvider.nameController,
                  hint: "Tech Distributors Inc.",
                ),
                SizedBox(height: 16.h),
                SFOInputField(
                  label: "Contact Person",
                  controller: formProvider.contactController,
                  hint: "Jane Doe",
                ),
                SizedBox(height: 16.h),
                SFOInputField(
                  label: "Email",
                  controller: formProvider.emailController,
                  hint: "jane@company.com",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),
                SFOInputField(
                  label: "Phone",
                  controller: formProvider.phoneController,
                  hint: "+63 917 123 4567",
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.h),
                SFOInputField(
                  label: "Address",
                  controller: formProvider.addressController,
                  hint: "100 Industrial Ave, Manila",
                  maxLines: 2,
                ),
                SizedBox(height: 16.h),
                SFODropdown<String>(
                  label: "Category",
                  value: formProvider.selectedCategory,
                  items: ["Electronics", "Components", "Accessories", "Software"]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: formProvider.setCategory,
                  hint: "Select category",
                ),
                SizedBox(height: 32.h),
                SFOButton(
                  text: formProvider.isEditing ? "Save Changes" : "Add Vendor",
                  onPressed: () => _save(context, formProvider),
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
