import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/services/hive/hive_service.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/business/business_details_card.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);

    return Scaffold(
      appBar: const SFOHeader(
        title: "Business Information",
        subtitle: "Manage your store details",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            BusinessDetailsCard(
              nameController: businessProvider.nameController,
              phoneController: businessProvider.phoneController,
              addressController: businessProvider.addressController,
              logoPath: businessProvider.logoPath,
              onLogoPicked: (source) => businessProvider.pickLogo(source),
              onLogoRemoved: () => businessProvider.removeLogo(),
              selectedCurrency: businessProvider.selectedCurrency,
              onCurrencyChanged: (Currency? value) {
                if (value != null) {
                  businessProvider.setCurrency(value);
                }
              },
              onSave: () {
                businessProvider.saveBusiness();
                Navigator.pop(context);
              },
              onLogout: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset App?"),
        content: const Text(
          "This will clear all business data and settings. This action cannot be undone. Are you sure?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Close all boxes first to avoid type conflicts or file locks
              await Hive.close();

              final boxes = [
                HiveService.settingsBox,
                HiveService.businessBox,
                HiveService.taxBox,
                HiveService.invoiceBox,
                HiveService.categoriesBox,
                HiveService.brandsBox,
                HiveService.productsBox,
                HiveService.salesBox,
                HiveService.salesOrdersBox,
                HiveService.customersBox,
                HiveService.vendorsBox,
                HiveService.purchaseOrdersBox,
              ];

              for (final boxName in boxes) {
                await Hive.deleteBoxFromDisk(boxName);
              }

              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.splash,
                  (route) => false,
                );
              }
            },
            child: const Text(
              "Reset",
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
