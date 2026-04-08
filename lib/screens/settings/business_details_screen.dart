import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/business/business_details_card.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final businessProvider = Provider.of<BusinessProvider>(context);

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
              "Business Information",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "Manage your store details",
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: BusinessDetailsCard(
          nameController: businessProvider.nameController,
          phoneController: businessProvider.phoneController,
          addressController: businessProvider.addressController,
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
        ),
      ),
    );
  }
}
