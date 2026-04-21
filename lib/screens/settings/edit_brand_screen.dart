import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/brand/brand_model.dart';
import 'package:shelfo/provider/brand_provider.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';

class EditBrandScreen extends StatelessWidget {
  final Brand? brand;
  const EditBrandScreen({super.key, this.brand});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Initialize provider data when building the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BrandProvider>(context, listen: false).initBrand(brand);
    });

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
              brand == null ? "Add Brand" : "Edit Brand",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              brand == null ? "Create a new product brand" : "Update brand details",
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: Consumer<BrandProvider>(
        builder: (context, provider, _) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              SFOCard(
                padding: const EdgeInsets.all(20),
                children: [
                  SFOInputField(
                    label: "Brand Name",
                    hint: "e.g. Apple",
                    controller: provider.nameController,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              SFOButton(
                text: brand == null ? "Create Brand" : "Save Changes",
                onPressed: () => _save(context, provider),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _save(BuildContext context, BrandProvider provider) async {
    if (provider.nameController.text.isEmpty) {
      SFOSnackbar.show(
        context,
        message: "Please enter a brand name",
        isError: true,
      );
      return;
    }

    final success = await provider.saveBrand(brand);
    
    if (context.mounted) {
      if (!success) {
        SFOSnackbar.show(
          context,
          message: "Brand with this name already exists",
          isError: true,
        );
      } else {
        Navigator.pop(context);
      }
    }
  }
}
