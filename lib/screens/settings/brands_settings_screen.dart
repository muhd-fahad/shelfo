import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/screens/settings/edit_brand_screen.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dialog.dart';
import '../../models/brand/brand_model.dart';
import '../../provider/inventory/brand_provider.dart';

class BrandsSettingsScreen extends StatelessWidget {
  const BrandsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final brandProvider = Provider.of<BrandProvider>(context);

    return Scaffold(
      appBar: const SFOHeader(
        title: "Product Brands",
        subtitle: "Manage your product brands",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<BrandProvider>().initBrand(null);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditBrandScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: brandProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: EdgeInsets.all(20.r),
              itemCount: brandProvider.brands.length,
              separatorBuilder: (context, index) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final brand = brandProvider.brands[index];
                return Material(
                  color: theme.cardTheme.color,
                  shape: theme.cardTheme.shape!,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
                            size: 20.r,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          onPressed: () {
                            context.read<BrandProvider>().initBrand(brand);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditBrandScreen(brand: brand),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, size: 20.r, color: AppColors.error),
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
