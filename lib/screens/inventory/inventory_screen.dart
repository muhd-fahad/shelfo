import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/screens/inventory/edit_product_screen.dart';
import 'package:shelfo/widgets/sfo_common/sfo_summary_card.dart';
import 'package:shelfo/widgets/inventory/product_grid_item.dart';
import 'package:shelfo/widgets/inventory/inventory_filter_sheet.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_chip.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';

import '../../utils/theme/app_constants/colors.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final businessProvider = Provider.of<BusinessProvider>(context);
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const SFOHeader(title: "Inventory"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SFOButton(
              text: "New Product",
              icon: Icons.add,
              width: 140,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProductScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: SFOBackground(
        child: Consumer2<ProductProvider, CategoryProvider>(
          builder: (context, provider, categoryProvider, _) {
            return Column(
              children: [
              // Summary Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    SFOSummaryCard(
                      label: "Total",
                      value: provider.totalProducts.toString(),
                      type: SFOSummaryType.primary,
                    ),
                    const SizedBox(width: 12),
                    SFOSummaryCard(
                      label: "Low Stock",
                      value: provider.lowStockCount.toString(),
                      type: SFOSummaryType.warning,
                    ),
                    const SizedBox(width: 12),
                    SFOSummaryCard(
                      label: "Out of Stock",
                      value: provider.outOfStockCount.toString(),
                      type: SFOSummaryType.error,
                    ),
                  ],
                ),
              ),

              // Search and Filter Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SFOSearchBar(
                  hintText: "Search products...",
                  onChanged: (val) => provider.setSearchQuery(val),
                  onFilterTap: () => _showFilterSheet(context, categoryProvider, provider),
                ),
              ),

              // Categories Scroll
              Container(
                height: 48,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: theme.brightness == Brightness.dark ? colorScheme.outlineVariant : AppColors.borderLight,
                    ),
                  ),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final name = index == 0 ? "All" : categoryProvider.categories[index - 1].name;
                    final isSelected = (index == 0 && provider.selectedFilterCategory == null) || 
                                     (index != 0 && provider.selectedFilterCategory == name);
                    
                    return Center(
                      child: SFOChip(
                        label: name,
                        isSelected: isSelected,
                        onSelected: (val) => provider.setFilterCategory(name == "All" ? null : name),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Product Grid
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.filteredProducts.isEmpty
                        ? const Center(child: Text("No products found"))
                        : GridView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
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
      ),
    ),
  );
}

  void _showFilterSheet(BuildContext context, CategoryProvider catProvider, ProductProvider prodProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => InventoryFilterSheet(
        categoryProvider: catProvider,
        productProvider: prodProvider,
      ),
    );
  }
}
