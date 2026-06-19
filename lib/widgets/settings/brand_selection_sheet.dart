import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/brand/brand_model.dart';
import '../../provider/inventory/brand_provider.dart';
import '../../screens/settings/edit_brand_screen.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_search_bar.dart';

class BrandSelectionSheet extends StatelessWidget {
  const BrandSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brandProvider = context.watch<BrandProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: SFOSearchBar(
                  hintText: "Search brand...",
                  onChanged: (val) => brandProvider.setSearchQuery(val),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton.filled(
                onPressed: () async {
                  final newBrand = await Navigator.push<Brand>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditBrandScreen(),
                    ),
                  );
                  if (newBrand != null && context.mounted) {
                    Navigator.pop(context, newBrand);
                  }
                },
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 400.h,
          child: brandProvider.brands.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No brands found",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () async {
                          final newBrand = await Navigator.push<Brand>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditBrandScreen(),
                            ),
                          );
                          if (newBrand != null && context.mounted) {
                            Navigator.pop(context, newBrand);
                          }
                        },
                        child: const Text("Create New Brand"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: brandProvider.brands.length,
                  itemBuilder: (context, index) {
                    final brand = brandProvider.brands[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(
                          brand.name,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.pop(context, brand);
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
