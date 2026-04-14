import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/invoice_provider.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_switch_tile.dart';
import 'package:shelfo/widgets/invoice_preview_widget.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';

class InvoiceSettingsDetailScreen extends StatelessWidget {
  const InvoiceSettingsDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

    if (invoiceProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Invoice Settings",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "Customize your receipts and invoices",
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const InvoicePreviewWidget(),
            const SizedBox(height: 24),
            SFOCard(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SFOInputField(
                        label: "Invoice Prefix",
                        hint: "INV-",
                        controller: invoiceProvider.prefixController,
                      ),
                    ),
                    const SizedBox(width: 16),
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
                const SizedBox(height: 16),
                SFOInputField(
                  label: "Footer Text",
                  hint: "Thank you for your business!",
                  controller: invoiceProvider.footerTextController,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SFOCard(
              children: [
                SFOSwitchTile(
                  title: "Show Logo on Receipt",
                  subtitle: "Include your business logo in the printed receipt",
                  value: invoiceProvider.showLogo,
                  onChanged: (value) {
                    invoiceProvider.toggleShowLogo(value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 32),
            SFOButton(
              text: "Save Changes",
              onPressed: () async {
                await invoiceProvider.saveInvoiceConfig();
                if (context.mounted) {
                  SFOSnackbar.show(context, message: "Invoice settings updated successfully");
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
