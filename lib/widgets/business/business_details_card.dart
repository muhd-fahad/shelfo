import 'package:flutter/material.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';

import '../../models/currency/currency.dart';

class BusinessDetailsCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final Currency selectedCurrency;
  final ValueChanged<Currency?> onCurrencyChanged;
  final VoidCallback onSave;

  const BusinessDetailsCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: RoundedSuperellipseBorder(
          borderRadius: AppRadius.lg,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputWidget(
            title: "Store Name",
            hint: "Enter store name",
            controller: nameController,
          ),
          const SizedBox(height: 20),
          
          InputWidget(
            title: "Phone Number",
            hint: "Enter phone number",
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),

          _buildFieldLabel("Currency", isDark),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: ShapeDecoration(
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Currency>(
                value: selectedCurrency,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                onChanged: onCurrencyChanged,
                items: Currency.values.map<DropdownMenuItem<Currency>>((Currency value) {
                  return DropdownMenuItem<Currency>(
                    value: value,
                    child: Text("${value.code} (${value.symbol})"),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          InputWidget(
            title: "Address",
            hint: "Enter store address",
            controller: addressController,
            maxLines: 3,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save_outlined, size: 20),
              label: const Text("Save Changes"),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppRadius.md,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
      ),
    );
  }
}
