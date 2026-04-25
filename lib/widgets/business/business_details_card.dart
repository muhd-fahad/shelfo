import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import '../../models/currency/currency.dart';
import '../sfo_common/sfo_dropdown.dart';
import '../sfo_common/sfo_input_field.dart';

class BusinessDetailsCard extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String? logoPath;
  final Function(ImageSource) onLogoPicked;
  final VoidCallback onLogoRemoved;
  final Currency selectedCurrency;
  final ValueChanged<Currency?> onCurrencyChanged;
  final VoidCallback onSave;

  const BusinessDetailsCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.addressController,
    this.logoPath,
    required this.onLogoPicked,
    required this.onLogoRemoved,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: theme.cardTheme.color,
        shape: theme.cardTheme.shape!,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text("Business Logo",
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurfaceVariant,
              )),
          SFOLogoPicker(
            logoPath: logoPath,
            onPick: onLogoPicked,
            onRemove: onLogoRemoved,
            size: 96,
          ),

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
