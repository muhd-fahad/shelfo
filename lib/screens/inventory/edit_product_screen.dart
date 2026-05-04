import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/provider/product_provider.dart';
import 'package:shelfo/provider/category_provider.dart';
import 'package:shelfo/provider/brand_provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_snackbar.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dropdown.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_image_picker.dart';
import 'package:shelfo/widgets/inventory/product_type_selector.dart';

class EditProductScreen extends StatelessWidget {
  final Product? product;
  const EditProductScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencySymbol = Provider.of<BusinessProvider>(context).selectedCurrency.symbol;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).initProduct(product);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: SFOHeader(
          title: product == null ? "New Product" : "Edit Product",
        ),
        centerTitle: true,
      ),
      body: Consumer3<ProductProvider, CategoryProvider, BrandProvider>(
        builder: (context, provider, categoryProvider, brandProvider, _) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SFOSectionHeader(title: "Basic Info"),
                    const SizedBox(height: 12),
                    SFOCard(
                      padding: const EdgeInsets.all(16),
                      children: [
                        SFOInputField(
                          label: "Product Name",
                          hint: "e.g. Logitech G304 Mouse",
                          controller: provider.nameController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SFODropdown<String?>(
                                label: "Category",
                                value: provider.selectedCategory,
                                items: categoryProvider.categories.map((cat) {
                                  return DropdownMenuItem(value: cat.name, child: Text(cat.name));
                                }).toList(),
                                onChanged: (val) => provider.setCategory(val),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SFODropdown<String?>(
                                label: "Brand",
                                value: provider.selectedBrand,
                                items: brandProvider.brands.map((brand) {
                                  return DropdownMenuItem(value: brand.name, child: Text(brand.name));
                                }).toList(),
                                onChanged: (val) => provider.setBrand(val),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text("Product Type",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            )),
                        const SizedBox(height: 8),
                        ProductTypeSelector(
                          selectedType: provider.selectedType,
                          onTypeSelected: (type) => provider.setProductType(type),
                        ),
                        const SizedBox(height: 16),
                        Text("Product Image",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            )),
                        const SizedBox(height: 8),
                        SFOImagePicker(
                          imagePaths: provider.imagePaths,
                          onAddImage: (source) => provider.pickAndAddImage(source),
                          onRemoveImage: (index) => provider.removeImage(index),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const SFOSectionHeader(title: "Stock & Pricing"),
                    const SizedBox(height: 12),
                    SFOCard(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (product == null)
                          Row(
                            children: [
                              Expanded(
                                child: SFOInputField(
                                  label: "Initial Stock",
                                  hint: "0",
                                  controller: provider.initialStockController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SFOInputField(
                                  label: "Min Stock",
                                  hint: "5",
                                  controller: provider.minStockController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SFOInputField(
                                  label: "Reorder Point",
                                  hint: "10",
                                  controller: provider.reorderPointController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: SFOInputField(
                                  label: "Min Stock",
                                  hint: "5",
                                  controller: provider.minStockController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SFOInputField(
                                  label: "Reorder Point",
                                  hint: "10",
                                  controller: provider.reorderPointController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        SFOInputField(
                          label: "SKU",
                          hint: "LOG-G304",
                          controller: provider.skuController,
                          isRequired: true,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: SFOInputField(
                                label: "Purchase Price ($currencySymbol)",
                                hint: "0",
                                controller: provider.purchasePriceController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SFOInputField(
                                label: "Selling Price ($currencySymbol)",
                                hint: "0",
                                controller: provider.mrpController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SFOButton(
                text: product == null ? "Create Product" : "Save Changes",
                onPressed: () => _save(context, provider),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _save(BuildContext context, ProductProvider provider) async {
    if (provider.nameController.text.isEmpty) {
      SFOSnackbar.show(context, message: "Please enter product name", isError: true);
      return;
    }
    if (provider.skuController.text.isEmpty) {
      SFOSnackbar.show(context, message: "Please enter SKU", isError: true);
      return;
    }
    await provider.saveProduct(product);
    if (context.mounted) Navigator.pop(context);
  }
}
