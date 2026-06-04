import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/invoice_provider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
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
    final invoiceProvider = Provider.of<InvoiceProvider>(context);

    if (invoiceProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const SFOHeader(
        title: "Invoice Settings",
        subtitle: "Customize your receipts and invoices",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            const InvoicePreviewWidget(),
            SizedBox(height: 24.h),
            SFOCard(
              padding: EdgeInsets.all(16.r),
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
                    SizedBox(width: 16.w),
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
                SizedBox(height: 16.h),
                SFOInputField(
                  label: "Footer Text",
                  hint: "Thank you for your business!",
                  controller: invoiceProvider.footerTextController,
                ),
              ],
            ),
            SizedBox(height: 24.h),
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
            SizedBox(height: 32.h),
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
