import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/business/business_details_card.dart';

class BusinessDetailsScreen extends StatelessWidget {
  const BusinessDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SFOHeader(
          title: "Business Information",
          subtitle: "Manage your store details",
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
        ),
      ),
    );
  }
}
