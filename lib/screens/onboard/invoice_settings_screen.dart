import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/invoice_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/input_widget.dart';
import 'package:shelfo/widgets/invoice_preview_widget.dart';

class InvoiceSettingsScreen extends StatelessWidget {
  const InvoiceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

    if (invoiceProvider.isLoading) {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Column(
          spacing: 24,
          mainAxisAlignment: .start,
          crossAxisAlignment: .center,
          children: [
            const InvoicePreviewWidget(),
            Row(
              mainAxisSize: .max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: InputWidget(
                    title: "Invoice Prefix",
                    hint: "INV-",
                    controller: invoiceProvider.prefixController,
                  ),
                ),
                Expanded(
                  child: InputWidget(
                    title: "Starting Number",
                    hint: "1001",
                    controller: invoiceProvider.startingNumberController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            InputWidget(
              title: "Footer Text",
              hint: "Thank you for your business!",
              controller: invoiceProvider.footerTextController,
            ),
            Card(
              elevation: 0,
              shape: RoundedSuperellipseBorder(
                borderRadius: AppRadius.md,
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    const Text("Show Logo on Receipt"),
                    CupertinoSwitch(
                      value: invoiceProvider.showLogo,
                      onChanged: (value) {
                        invoiceProvider.toggleShowLogo(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  await invoiceProvider.saveInvoiceConfig();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.bottomNavbar,
                      (route) => false,
                    );
                  }
                },
                child: const Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: .center,
                  mainAxisAlignment: .center,
                  children: [
                    Text("Complete Setup"),
                    Icon(Icons.check_rounded),
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
