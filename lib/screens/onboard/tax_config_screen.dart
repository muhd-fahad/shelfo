import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/tax/tax_pricing_mode.dart';
import 'package:shelfo/provider/tax_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';

class TaxConfigScreen extends StatelessWidget {
  const TaxConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taxProvider = Provider.of<TaxProvider>(context);

    if (taxProvider.isLoading) {
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
              "Tax Configuration",
              style: SFOAppTheme.light.textTheme.titleLarge,
            ),
            Text(
              "Set up how taxes are calculated",
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
            Card(
              elevation: 0,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: const BorderSide(color: AppColors.border),
              ),
              child: ListTile(
                title: const Text("Enable Tax Calculation"),
                subtitle: const Text("Automatically calculate tax on sales"),
                subtitleTextStyle: SFOAppTheme.light.textTheme.bodyMedium,
                trailing: CupertinoSwitch(
                  value: taxProvider.isTaxEnabled,
                  onChanged: (value) {
                    taxProvider.toggleTaxEnabled(value);
                  },
                ),
              ),
            ),
            if (taxProvider.isTaxEnabled) ...[
              Row(
                mainAxisSize: .max,
                spacing: AppSpacing.lg,
                children: [
                  Expanded(
                    child: InputWidget(
                      title: "Default Tax Rate (%)",
                      hint: "8.5",
                      controller: taxProvider.taxRateController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  Expanded(
                    child: InputWidget(
                      title: "Tax Label",
                      hint: "Sales Tax",
                      controller: taxProvider.taxLabelController,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xs,
                children: [
                  Text(
                    "Tax Pricing Mode",
                    style: SFOAppTheme.light.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: .max,
                    spacing: AppSpacing.lg,
                    children: [
                      Expanded(
                        child: _PricingModeCard(
                          title: "Tax Exclusive",
                          isSelected: taxProvider.pricingMode == TaxPricingMode.exclusive,
                          onTap: () => taxProvider.setPricingMode(TaxPricingMode.exclusive),
                        ),
                      ),
                      Expanded(
                        child: _PricingModeCard(
                          title: "Tax Inclusive",
                          isSelected: taxProvider.pricingMode == TaxPricingMode.inclusive,
                          onTap: () => taxProvider.setPricingMode(TaxPricingMode.inclusive),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: AppSpacing.xs,
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        size: AppSpacing.md,
                        color: AppColors.textMuted,
                      ),
                      Text(
                        "How do you enter product prices?",
                        style: AppTextStyles.label,
                      )
                    ],
                  )
                ],
              ),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await taxProvider.saveTaxConfig();
                  if (context.mounted) {
                    Navigator.pushNamed(context, AppRoutes.invoiceSettings);
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
          shape: RoundedSuperellipseBorder(
            borderRadius: AppRadius.md,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
