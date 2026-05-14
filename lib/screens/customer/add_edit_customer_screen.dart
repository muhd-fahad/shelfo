import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/customer/customer_model.dart';
import '../../provider/customer_provider.dart';
import '../../provider/customer_form_provider.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_button.dart';
import '../../widgets/sfo_common/sfo_input_field.dart';
import '../../widgets/sfo_common/sfo_snackbar.dart';

class AddEditCustomerScreen extends StatelessWidget {
  final Customer? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CustomerFormProvider(customer),
      child: Consumer<CustomerFormProvider>(
        builder: (context, formProvider, child) {
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(customer == null ? "Add Customer" : "Edit Customer"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: formProvider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SFOInputField(
                      label: "Name",
                      hint: "Customer name",
                      controller: formProvider.nameController,
                      isRequired: true,
                      validator: (val) => val == null || val.isEmpty ? "Required" : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text("Type", style: theme.textTheme.labelLarge),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: _TypeButton(
                            label: "Business",
                            isSelected: formProvider.selectedType == CustomerType.business,
                            onTap: () => formProvider.setType(CustomerType.business),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _TypeButton(
                            label: "Individual",
                            isSelected: formProvider.selectedType == CustomerType.individual,
                            onTap: () => formProvider.setType(CustomerType.individual),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SFOInputField(
                      label: "Email",
                      hint: "email@example.com",
                      controller: formProvider.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SFOInputField(
                      label: "Phone",
                      hint: "+63 917 123 4567",
                      controller: formProvider.phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SFOInputField(
                      label: "Address",
                      hint: "123 Main St, Manila",
                      controller: formProvider.addressController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SFOInputField(
                      label: "Credit Limit (₹)",
                      hint: "10000",
                      controller: formProvider.creditLimitController,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: AppSpacing.xxl * 2),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: SFOButton(
                text: customer == null ? "Add Customer" : "Save Changes",
                onPressed: () => _save(context, formProvider),
                backgroundColor: customer == null ? null : AppColors.success,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _save(BuildContext context, CustomerFormProvider formProvider) async {
    if (!formProvider.formKey.currentState!.validate()) return;

    final provider = context.read<CustomerProvider>();
    final newCustomer = Customer(
      id: customer?.id ?? const Uuid().v4(),
      name: formProvider.nameController.text.trim(),
      type: formProvider.selectedType,
      email: formProvider.emailController.text.trim(),
      phone: formProvider.phoneController.text.trim(),
      address: formProvider.addressController.text.trim(),
      creditLimit: double.tryParse(formProvider.creditLimitController.text) ?? 0,
      createdAt: customer?.createdAt ?? DateTime.now(),
    );

    if (customer == null) {
      await provider.addCustomer(newCustomer);
    } else {
      await provider.updateCustomer(newCustomer);
    }

    if (context.mounted) {
      Navigator.pop(context);
      SFOSnackbar.show(
        context,
        message: customer == null ? "Customer added" : "Customer updated",
      );
    }
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.success.withValues(alpha: 0.1) : colorScheme.surface,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.md,
            side: BorderSide(
              color: isSelected ? AppColors.success : colorScheme.outlineVariant,
              width: isSelected ? 1.5 : 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected ? AppColors.success : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
