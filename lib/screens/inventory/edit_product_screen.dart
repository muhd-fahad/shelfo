import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: SFOHeader(
        title: product == null ? "New Product" : "Edit Product",
      ),
      body: Consumer3<ProductProvider, CategoryProvider, BrandProvider>(
        builder: (context, provider, categoryProvider, brandProvider, _) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SFOSectionHeader(title: "Basic Info"),
                    SizedBox(height: 12.h),
                    SFOCard(
                      padding: EdgeInsets.all(16.r),
                      children: [
                        SFOInputField(
                          label: "Product Name",
                          hint: "e.g. Logitech G304 Mouse",
                          controller: provider.nameController,
                          isRequired: true,
                        ),
                        SizedBox(height: 16.h),
                        SFOInputField(
                          label: "Description",
                          hint: "Add product description...",
                          controller: provider.descriptionController,
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),
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
                            SizedBox(width: 16.w),
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
                        SizedBox(height: 16.h),
                        Text("Product Type",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            )),
                        SizedBox(height: 8.h),
                        ProductTypeSelector(
                          selectedType: provider.selectedType,
                          onTypeSelected: (type) => provider.setProductType(type),
                        ),
                        SizedBox(height: 16.h),
                        Text("Product Image",
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            )),
                        SizedBox(height: 8.h),
                        SFOImagePicker(
                          imagePaths: provider.imagePaths,
                          onAddImage: (source) => provider.pickAndAddImage(source),
                          onRemoveImage: (index) => provider.removeImage(index),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    const SFOSectionHeader(title: "Stock & Pricing"),
                    SizedBox(height: 12.h),
                    SFOCard(
                      padding: EdgeInsets.all(16.r),
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
                              SizedBox(width: 12.w),
                              Expanded(
                                child: SFOInputField(
                                  label: "Min Stock",
                                  hint: "5",
                                  controller: provider.minStockController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 12.w),
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
                              SizedBox(width: 12.w),
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
                        SizedBox(height: 16.h),
                        SFOInputField(
                          label: "SKU",
                          hint: "LOG-G304",
                          controller: provider.skuController,
                          isRequired: true,
                        ),
                        SizedBox(height: 16.h),
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
                            SizedBox(width: 16.w),
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
              padding: EdgeInsets.all(20.r),
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
