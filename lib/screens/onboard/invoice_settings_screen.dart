import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/invoice_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
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
      appBar: const SFOHeader(
        title: "Invoice Settings",
        subtitle: "Customize your receipts and invoices",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: invoiceProvider.formKey,
          child: Column(
            spacing: 24.h,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      isRequired: true,
                    ),
                  ),
                  Expanded(
                    child: SFOInputField(
                      label: "Starting Number",
                      hint: "1001",
                      controller: invoiceProvider.startingNumberController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
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
                  if (invoiceProvider.formKey.currentState?.validate() ?? false) {
                    await invoiceProvider.saveInvoiceConfig();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.bottomNavbar,
                        (route) => false,
                      );
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
