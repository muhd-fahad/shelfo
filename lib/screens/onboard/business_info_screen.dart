import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dropdown.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';

import '../../utils/theme/theme.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);

    if (businessProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Business Details",
              style: SFOAppTheme.light.textTheme.titleLarge,
            ),
            Text(
              "Tell us about your store",
              style: SFOAppTheme.light.textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          spacing: 24,
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            SFOLogoPicker(
              logoPath: businessProvider.logoPath,
              isDark: Theme.of(context).brightness == Brightness.dark,
              onPick: (source) => businessProvider.pickLogo(source),
              onRemove: () => businessProvider.removeLogo(),
              size: 96,
            ),
    
            SFOInputField(
              label: "Store Name",
              hint: "e.g. Techno Mobiles",
              controller: businessProvider.nameController,
              isRequired: true,
            ),
    
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: SFOInputField(
                    label: "Phone Number",
                    hint: "+1 (555) 000-0000",
                    controller: businessProvider.phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Expanded(
                  child: SFODropdown<Currency>(
                    label: "Currency",
                    value: businessProvider.selectedCurrency,
                    items: Currency.values.map((Currency value) {
                      return DropdownMenuItem<Currency>(
                        value: value,
                        child: Text("${value.code} (${value.symbol})"),
                      );
                    }).toList(),
                    onChanged: (Currency? newValue) {
                      if (newValue != null) {
                        businessProvider.setCurrency(newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            SFOInputField(
              label: "Address",
              hint: "Store address...",
              controller: businessProvider.addressController,
              maxLines: 3,
            ),
            SFOButton(
              text: "Continue",
              icon: Icons.arrow_forward_rounded,
              onPressed: () async {
                await businessProvider.saveBusiness();
                if (context.mounted) {
                  Navigator.pushNamed(context, AppRoutes.taxConfig);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
