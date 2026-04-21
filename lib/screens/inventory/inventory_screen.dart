import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/screens/inventory/edit_product_screen.dart';
import 'package:shelfo/utils/theme/theme_constants.dart';
import 'package:shelfo/widgets/sfo_common/sfo_summary_card.dart';
import 'package:shelfo/widgets/inventory/product_grid_item.dart';
import 'package:shelfo/widgets/inventory/inventory_filter_sheet.dart';
import 'package:shelfo/widgets/sfo_common/sfo_search_bar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_chip.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final businessProvider = Provider.of<BusinessProvider>(context);
    final currency = businessProvider.selectedCurrency;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Inventory",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
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
      body: Consumer2<ProductProvider, CategoryProvider>(
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
                      bgColor: isDark ? const Color(0xFF1E293B) : const Color(0xFF0F172A),
                      textColor: Colors.white,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    SFOSummaryCard(
                      label: "Low Stock",
                      value: provider.lowStockCount.toString(),
                      bgColor: isDark ? const Color(0xFF451A03) : const Color(0xFFFFF7ED),
                      textColor: isDark ? Colors.orangeAccent : Colors.orange.shade900,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 12),
                    SFOSummaryCard(
                      label: "Out of Stock",
                      value: provider.outOfStockCount.toString(),
                      bgColor: isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2),
                      textColor: isDark ? Colors.redAccent : Colors.red.shade900,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              // Search and Filter Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: SFOSearchBar(
                  isDark: isDark,
                  hintText: "Search products...",
                  onChanged: (val) => provider.setSearchQuery(val),
                  onFilterTap: () => _showFilterSheet(context, categoryProvider, provider),
                ),
              ),

              // Categories Scroll
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
                    ),
                  ),
                ),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryProvider.categories.length + 1,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final name = index == 0 ? "All" : categoryProvider.categories[index - 1].name;
                    final isSelected = (index == 0 && provider.selectedFilterCategory == null) || 
                                     (index != 0 && provider.selectedFilterCategory == name);
                    
                    return SFOChip(
                      label: name,
                      isSelected: isSelected,
                      onSelected: (val) => provider.setFilterCategory(name == "All" ? null : name),
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
                                isDark: isDark,
                              );
                            },
                          ),
              ),
            ],
          );
        },
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
