import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/screens/inventory/edit_product_screen.dart';
import 'package:shelfo/widgets/sfo_common/sfo_empty_state.dart';
import 'package:shelfo/widgets/sfo_common/sfo_summary_card.dart';
import 'package:shelfo/widgets/inventory/product_grid_item.dart';
import 'package:shelfo/widgets/inventory/inventory_filter_sheet.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_chip.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';

import '../../models/currency/currency.dart';
import '../../provider/business/business_provider.dart';
import '../../provider/inventory/brand_provider.dart';
import '../../provider/inventory/category_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../utils/theme/app_constants/colors.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final businessProvider = Provider.of<BusinessProvider>(context);
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: const SFOHeader(title: "Inventory"),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildContent(context, theme, colorScheme, currency, 2, 16.w),
          tablet: _buildContent(context, theme, colorScheme, currency, 3, 32.w),
          desktop: _buildContent(context, theme, colorScheme, currency, 5, 32.w),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        isExtended: false,
        icon: Icon(Icons.add, size: 24.r),
        label: const Text("Add"),
        onPressed: () {
          context.read<ProductProvider>().initProduct(null);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProductScreen()),
          );
        },
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    Currency currency,
    int crossAxisCount,
    double horizontalPadding,
  ) {
    final isTablet = SFOResponsive.isTablet(context) || SFOResponsive.isDesktop(context);
    
    return Consumer2<ProductProvider, CategoryProvider>(
      builder: (context, provider, categoryProvider, _) {
        return Column(
          children: [
            // Summary Cards
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: SFOSummaryCard(
                      label: "Total",
                      value: provider.totalProducts.toString(),
                      type: SFOSummaryType.primary,
                      onTap: () => provider.clearFilters(),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SFOSummaryCard(
                      label: "Low Stock",
                      value: provider.lowStockCount.toString(),
                      type: SFOSummaryType.warning,
                      onTap: () {
                        provider.clearFilters();
                        provider.toggleStockStatus('Low Stock');
                      },
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: SFOSummaryCard(
                      label: "Out of Stock",
                      value: provider.outOfStockCount.toString(),
                      type: SFOSummaryType.error,
                      onTap: () {
                        provider.clearFilters();
                        provider.toggleStockStatus('Out of Stock');
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Search and Filter Bar
            Padding(
              padding: EdgeInsets.all(isTablet ? 24.r : 16.r),
              child: SFOSearchBar(
                hintText: "Search products...",
                controller: provider.searchController,
                onFilterTap: () => _showFilterSheet(context, categoryProvider, provider),
              ),
            ),

            // Categories Scroll
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.brightness == Brightness.dark ? colorScheme.outlineVariant : AppColors.borderLight,
                  ),
                ),
              ),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4.h),
                scrollDirection: Axis.horizontal,
                itemCount: categoryProvider.categories.length + 1,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final name = index == 0 ? "All" : categoryProvider.categories[index - 1].name;
                  final isSelected = (index == 0 && provider.selectedFilterCategories.isEmpty) ||
                      (index != 0 && provider.selectedFilterCategories.contains(name));

                  return Center(
                    child: SFOChip(
                      label: name,
                      isSelected: isSelected,
                      onSelected: (val) => provider.toggleFilterCategory(name == "All" ? null : name),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16.h),

            // Product Grid
            Expanded(
              child: provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : provider.filteredProducts.isEmpty
                      ? const SFOEmptyState(
                          title: "No products found",
                          subtitle: "Start by adding some products to your inventory",
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 3/4.35,
                            crossAxisSpacing: 16.r,
                            mainAxisSpacing: 16.r,
                          ),
                          itemCount: provider.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = provider.filteredProducts[index];
                            return ProductGridItem(
                              product: product,
                              currency: currency,
                            );
                          },
                        ),
            ),
            
          ],
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context, CategoryProvider catProvider, ProductProvider prodProvider) {
    catProvider.clearSearch();
    context.read<BrandProvider>().clearSearch();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (context) => const InventoryFilterSheet(),
    );
  }
}
