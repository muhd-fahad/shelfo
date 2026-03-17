import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';

class TaxConfigScreen extends StatelessWidget {
  const TaxConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: .start,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          spacing: 24,
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
         

            Card(
              
              child: ListTile(
                title: Text("Enable Tax Calculation"),
                subtitle: Text("Automatically calculate tax on sales"),
                subtitleTextStyle: SFOAppTheme.light.textTheme.bodyMedium,
                trailing: CupertinoSwitch(value: true, onChanged: (value) {
                  
                },),
              ),
            ),

            Row(
              mainAxisSize: .max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: InputWidget(
                    title: "Default Tax Rate (%)",
                    hint: "8.5",
                  ),
                ),
                Expanded(
                  child: InputWidget(title: "Tax Label", hint: "Sales Tax"),
                ),
              ],
            ),
            Column(
              spacing: AppSpacing.xs,
              children: [
                Row(
                  mainAxisSize: .max,
                  spacing: AppSpacing.lg,
                  children: [
                    Expanded(
                      child: InputWidget(
                        title: "Tax Pricing Mode",
                        hint: "Tax Exclusive",
                      ),
                    ),
                    Expanded(
                      child: InputWidget(title: " ", hint: "Tax Inclusive"),
                    ),
                  ],
                ),
                Row(
                  spacing: AppSpacing.xs,
                  children: [
                    Icon(Icons.info_outline_rounded,size: AppSpacing.md,color: AppColors.textMuted,),
                    Text("How do you enter product prices?",style: AppTextStyles.label,)
                  ],
                )
              ],
            ),
            SizedBox(
              width: .infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.invoiceSettings);
                },
                child: Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
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
