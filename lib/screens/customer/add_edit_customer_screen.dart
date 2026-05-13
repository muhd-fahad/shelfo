import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../models/customer/customer_model.dart';
import '../../provider/customer_provider.dart';
import '../../utils/theme/theme.dart';
import '../../widgets/sfo_common/sfo_button.dart';
import '../../widgets/sfo_common/sfo_input_field.dart';
import '../../widgets/sfo_common/sfo_snackbar.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;

  const AddEditCustomerScreen({super.key, this.customer});

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _creditLimitController;
  CustomerType _selectedType = CustomerType.business;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer?.name);
    _emailController = TextEditingController(text: widget.customer?.email);
    _phoneController = TextEditingController(text: widget.customer?.phone);
    _addressController = TextEditingController(text: widget.customer?.address);
    _creditLimitController = TextEditingController(
      text: widget.customer?.creditLimit.toString() ?? "10000",
    );
    _selectedType = widget.customer?.type ?? CustomerType.business;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<CustomerProvider>();
    final customer = Customer(
      id: widget.customer?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      creditLimit: double.tryParse(_creditLimitController.text) ?? 0,
      createdAt: widget.customer?.createdAt ?? DateTime.now(),
    );

    if (widget.customer == null) {
      await provider.addCustomer(customer);
    } else {
      await provider.updateCustomer(customer);
    }

    if (mounted) {
      Navigator.pop(context);
      SFOSnackbar.show(
        context,
        message: widget.customer == null ? "Customer added" : "Customer updated",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.customer == null ? "Add Customer" : "Edit Customer"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SFOInputField(
                label: "Name",
                hint: "Customer name",
                controller: _nameController,
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
                      isSelected: _selectedType == CustomerType.business,
                      onTap: () => setState(() => _selectedType = CustomerType.business),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _TypeButton(
                      label: "Individual",
                      isSelected: _selectedType == CustomerType.individual,
                      onTap: () => setState(() => _selectedType = CustomerType.individual),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SFOInputField(
                label: "Email",
                hint: "email@example.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.lg),
              SFOInputField(
                label: "Phone",
                hint: "+63 917 123 4567",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),
              SFOInputField(
                label: "Address",
                hint: "123 Main St, Manila",
                controller: _addressController,
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.lg),
              SFOInputField(
                label: "Credit Limit (₹)",
                hint: "10000",
                controller: _creditLimitController,
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
          text: widget.customer == null ? "Add Customer" : "Save Changes",
          onPressed: _save,
          backgroundColor: widget.customer == null ? null : AppColors.success,
        ),
      ),
    );
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
