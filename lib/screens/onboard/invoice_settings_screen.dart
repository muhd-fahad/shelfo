import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';
import 'package:shelfo/widgets/invoice_preview_widget.dart';

class InvoiceSettingsScreen extends StatelessWidget {
  const InvoiceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Invoice Settings",
              style: SFOAppTheme.light.textTheme.titleLarge,
            ),
            Text(
              "Customize your receipts and invoices",
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
            InvoicePreviewWidget(),
            Row(
              mainAxisSize: .max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: InputWidget(title: "Invoice Prefix", hint: "INV-"),
                ),
                Expanded(
                  child: InputWidget(title: "Starting Number", hint: "1001"),
                ),
              ],
            ),
            InputWidget(
              title: "Footer Text",
              hint: "Thank you for your business!",
            ),
            Card(
              // child: ListTile(
              //   // title: Text("Enable Tax Calculation"),
              //   subtitle: Text("Show Logo on Receipt"),
              //   subtitleTextStyle: SFOAppTheme.light.textTheme.bodyMedium,
              //   trailing: CupertinoSwitch(value: true, onChanged: (value) {

              //   },),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Text("Show Logo on Receipt"),
                    CupertinoSwitch(value: true, onChanged: (value) {}),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: .infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.bottomNavbar,
                    (route) => false,
                  );
                },
                child: Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [Text("Complete Setup"), Icon(Icons.check_rounded)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
