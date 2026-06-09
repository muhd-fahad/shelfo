import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/tax/tax_pricing_mode.dart';
import 'package:shelfo/provider/tax_provider.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_switch_tile.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';

class TaxSettingsScreen extends StatelessWidget {
  const TaxSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final taxProvider = Provider.of<TaxProvider>(context);

    if (taxProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const SFOHeader(
        title: "Tax Configuration",
        subtitle: "Manage tax rates and calculation",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: taxProvider.formKey,
          child: Column(
            children: [
              SFOCard(
                children: [
                  SFOSwitchTile(
                    title: "Enable Tax Calculation",
                    subtitle: "Automatically calculate tax on sales",
                    value: taxProvider.isTaxEnabled,
                    onChanged: (value) {
                      taxProvider.toggleTaxEnabled(value);
                    },
                  ),
                ],
              ),
              if (taxProvider.isTaxEnabled) ...[
                SizedBox(height: 24.h),
                SFOCard(
                  padding: EdgeInsets.all(16.r),
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: SFOInputField(
                            label: "Default Tax Rate (%)",
                            hint: "8.5",
                            controller: taxProvider.taxRateController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            isRequired: true,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: SFOInputField(
                            label: "Tax Label",
                            hint: "Sales Tax",
                            controller: taxProvider.taxLabelController,
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Tax Pricing Mode",
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: _PricingModeCard(
                            title: "Tax Exclusive",
                            isSelected: taxProvider.pricingMode == TaxPricingMode.exclusive,
                            onTap: () => taxProvider.setPricingMode(TaxPricingMode.exclusive),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _PricingModeCard(
                            title: "Tax Inclusive",
                            isSelected: taxProvider.pricingMode == TaxPricingMode.inclusive,
                            onTap: () => taxProvider.setPricingMode(TaxPricingMode.inclusive),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16.r,
                          color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "How do you enter product prices?",
                          style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
                        )
                      ],
                    )
                  ],
                ),
              ],
              SizedBox(height: 32.h),
              SFOButton(
                text: "Save Changes",
                onPressed: () async {
                  if (taxProvider.formKey.currentState?.validate() ?? false) {
                    await taxProvider.saveTaxConfig();
                    if (context.mounted) {
                      SFOSnackbar.show(context, message: "Tax settings updated successfully");
                      Navigator.pop(context);
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PricingModeCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PricingModeCard({
    required this.title,
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
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: ShapeDecoration(
          color: isSelected ? colorScheme.primary.withOpacity(0.05) : Colors.transparent,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.md,
            side: BorderSide(
              color: isSelected ? colorScheme.primary : colorScheme.outline,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
