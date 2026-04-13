import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';

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
            Container(
              height: 96,
              width: 96,
              decoration: ShapeDecoration(
                color: Colors.grey.shade200,
                shape: RoundedSuperellipseBorder(
                  borderRadius: AppRadius.xl,
                  side: const BorderSide(width: 2, color: AppColors.border),
                ),
              ),
              child: const Icon(Icons.add_a_photo_outlined, color: Colors.grey),
            ),
    
            InputWidget(
              title: "Store Name",
              hint: "e.g. Techno Mobiles",
              controller: businessProvider.nameController,
            ),
    
            Row(
              mainAxisSize: MainAxisSize.max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: InputWidget(
                    title: "Phone Number",
                    hint: "+1 (555) 000-0000",
                    controller: businessProvider.phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Currency",
                        style: SFOAppTheme.light.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: ShapeDecoration(
                          shape: RoundedSuperellipseBorder(
                            borderRadius: AppRadius.md,
                            side: const BorderSide(color: AppColors.border),
                          ),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<Currency>(
                            value: businessProvider.selectedCurrency,
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                            onChanged: (Currency? newValue) {
                              if (newValue != null) {
                                businessProvider.setCurrency(newValue);
                              }
                            },
                            items: Currency.values.map<DropdownMenuItem<Currency>>((Currency value) {
                              return DropdownMenuItem<Currency>(
                                value: value,
                                child: Text("${value.code} (${value.symbol})"),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InputWidget(
              title: "Address",
              hint: "Store address...",
              controller: businessProvider.addressController,
              maxLines: 3,
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await businessProvider.saveBusiness();
                  if (context.mounted) {
                    Navigator.pushNamed(context, AppRoutes.taxConfig);
                  }
                },
                child: const Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Continue"),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
