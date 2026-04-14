import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/invoice_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_switch_tile.dart';
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
              mainAxisSize: MainAxisSize.max,
              spacing: AppSpacing.lg,
              children: [
                Expanded(
                  child: SFOInputField(
                    label: "Invoice Prefix",
                    hint: "INV-",
                    controller: invoiceProvider.prefixController,
                  ),
                ),
                Expanded(
                  child: SFOInputField(
                    label: "Starting Number",
                    hint: "1001",
                    controller: invoiceProvider.startingNumberController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SFOInputField(
              label: "Footer Text",
              hint: "Thank you for your business!",
              controller: invoiceProvider.footerTextController,
            ),
            SFOSwitchTile(
              title: "Show Logo on Receipt",
              subtitle: "Include your business logo in the printed receipt",
              value: invoiceProvider.showLogo,
              onChanged: (value) {
                invoiceProvider.toggleShowLogo(value);
              },
            ),
            SFOButton(
              text: "Complete Setup",
              icon: Icons.check_rounded,
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
            ),
          ],
        ),
      ),
    );
  }
}
