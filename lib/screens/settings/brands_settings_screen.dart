import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/brand_provider.dart';
import 'package:shelfo/screens/settings/edit_brand_screen.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';

import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';
import '../../models/brand/brand_model.dart';

class BrandsSettingsScreen extends StatelessWidget {
  const BrandsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final brandProvider = Provider.of<BrandProvider>(context);

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
              "Product Brands",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Text(
              "Manage your product brands",
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditBrandScreen(),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: brandProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: brandProvider.brands.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final brand = brandProvider.brands[index];
                return Container(
                  decoration: ShapeDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: RoundedSuperellipseBorder(
                      borderRadius: AppRadius.md,
                      side: BorderSide(
                        color: isDark ? AppColors.darkBorder : AppColors.border,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Text(
                      brand.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit_outlined,
                            size: 20,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditBrandScreen(brand: brand),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Colors.redAccent),
                          onPressed: () => _showDeleteConfirmation(context, brand),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, Brand brand) {
    SFODialog.show(
      context,
      title: "Delete Brand",
      message: "Are you sure you want to delete '${brand.name}'?",
      primaryActionText: "Delete",
      onPrimaryAction: () {
        Provider.of<BrandProvider>(context, listen: false).deleteBrand(brand);
        Navigator.pop(context);
      },
      secondaryActionText: "Cancel",
      isDestructive: true,
    );
  }
}
