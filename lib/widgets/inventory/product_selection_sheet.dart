import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_model.dart';
import '../../provider/inventory/product_provider.dart';
import '../../screens/inventory/edit_product_screen.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_search_bar.dart';

class ProductSelectionSheet extends StatelessWidget {
  const ProductSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final productProvider = context.watch<ProductProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: SFOSearchBar(
                  hintText: "Search product...",
                  onChanged: (val) => productProvider.setSearchQuery(val),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton.filled(
                onPressed: () async {
                  final newProduct = await Navigator.push<Product>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditProductScreen(),
                    ),
                  );
                  if (newProduct != null && context.mounted) {
                    Navigator.pop(context, newProduct);
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
          child: productProvider.filteredProducts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No products found",
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () async {
                          final newProduct = await Navigator.push<Product>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditProductScreen(),
                            ),
                          );
                          if (newProduct != null && context.mounted) {
                            Navigator.pop(context, newProduct);
                          }
                        },
                        child: const Text("Create New Product"),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: productProvider.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.filteredProducts[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: product.imagePaths != null && product.imagePaths!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.network(product.imagePaths![0], fit: BoxFit.cover),
                                )
                              : const Icon(Icons.inventory_2_outlined, color: AppColors.primary),
                        ),
                        title: Text(
                          product.name,
                          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "SKU: ${product.sku ?? 'N/A'} • Stock: ${product.stockQuantity}",
                          style: theme.textTheme.bodySmall,
                        ),
                        onTap: () {
                          Navigator.pop(context, product);
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
