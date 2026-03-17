import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';

import '../../utils/theme/theme.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: .start,
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
      body: Padding(
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
                  side: BorderSide(width: 2, color: AppColors.border),
                ),
              ),
            ),
    
            InputWidget(title: "Store Name", hint: "e.g. Techno Mobiles"),
    
            Row(
              mainAxisSize: .max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: InputWidget(
                    title: "Phone Number",
                    hint: "+1 (555) 000-0000",
                  ),
                ),
                Expanded(
                  child: InputWidget(title: "Currency", hint: "INR (₹)"),
                ),
              ],
            ),
            InputWidget(title: "Address", hint: "Store address..."),
            SizedBox(
              width: .infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.taxConfig);
                }, child: Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [
                    Text("Continue"),
                    Icon(Icons.arrow_forward_rounded),
                  ],
                )),
            ),
          ],
        ),
      ),
    );
  }
}
