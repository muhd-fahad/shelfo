import 'package:flutter/material.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

import '../../models/currency/currency.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_dropdown.dart';
import '../sfo_common/sfo_input_field.dart';

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
        spacing: 20,
        children: [
          SFOInputField(
            label: "Store Name",
            hint: "Enter store name",
            controller: nameController,
          ),
          
          SFOInputField(
            label: "Phone Number",
            hint: "Enter phone number",
            controller: phoneController,
            keyboardType: TextInputType.phone,
          ),

          SFODropdown<Currency>(
            label: "Currency",
            value: selectedCurrency,
            items: Currency.values.map((Currency value) {
              return DropdownMenuItem<Currency>(
                value: value,
                child: Text("${value.code} (${value.symbol})"),
              );
            }).toList(),
            onChanged: onCurrencyChanged,
          ),

          SFOInputField(
            label: "Address",
            hint: "Enter store address",
            controller: addressController,
            maxLines: 3,
          ),

          SFOButton(
            text: "Save Changes",
            icon: Icons.save_outlined,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}
