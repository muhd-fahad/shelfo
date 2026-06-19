import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_selection_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_bottom_sheet.dart';
import 'package:shelfo/widgets/settings/category_selection_sheet.dart';
import 'package:shelfo/widgets/settings/brand_selection_sheet.dart';
import 'package:shelfo/models/category/category_model.dart';
import 'package:shelfo/models/brand/brand_model.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_image_picker.dart';
import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';

import '../../provider/business/business_provider.dart';
import '../../provider/inventory/brand_provider.dart';
import '../../provider/inventory/category_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../widgets/inventory/product_type_selector.dart';

class EditProductScreen extends StatelessWidget {
  final Product? product;
  const EditProductScreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencySymbol = Provider.of<BusinessProvider>(context).selectedCurrency.symbol;

    return Scaffold(
      appBar: SFOHeader(
        title: product == null ? "New Product" : "Edit Product",
      ),
      body: Consumer3<ProductProvider, CategoryProvider, BrandProvider>(
        builder: (context, provider, categoryProvider, brandProvider, _) => Form(
          key: provider.formKey,
          child: SFOResponsive(
            mobile: _buildFormContent(context, provider, categoryProvider, brandProvider, theme, colorScheme, currencySymbol),
            desktop: SFOResponsive.constrained(
              _buildFormContent(context, provider, categoryProvider, brandProvider, theme, colorScheme, currencySymbol),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    ProductProvider provider,
    CategoryProvider categoryProvider,
    BrandProvider brandProvider,
    ThemeData theme,
    ColorScheme colorScheme,
    String currencySymbol,
  ) {
    return Column(
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
                          child: SFOSelectionField(
                            label: "Category",
                            value: provider.selectedCategory,
                            onTap: () async {
                              final category = await SFOBottomSheet.show<Category>(
                                context,
                                title: "Select Category",
                                child: const CategorySelectionSheet(),
                              );
                              if (category != null) {
                                provider.setCategory(category.name);
                              }
                            },
                            hint: "Select category",
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: SFOSelectionField(
                            label: "Brand",
                            value: provider.selectedBrand,
                            onTap: () async {
                              final brand = await SFOBottomSheet.show<Brand>(
                                context,
                                title: "Select Brand",
                                child: const BrandSelectionSheet(),
                              );
                              if (brand != null) {
                                provider.setBrand(brand.name);
                              }
                            },
                            hint: "Select brand",
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
                              isRequired: true,
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
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            isRequired: true,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: SFOInputField(
                            label: "Selling Price ($currencySymbol)",
                            hint: "0",
                            controller: provider.mrpController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            isRequired: true,
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
    );
  }

  void _save(BuildContext context, ProductProvider provider) async {
    if (provider.formKey.currentState?.validate() ?? false) {
      await provider.saveProduct(product);
      if (context.mounted) Navigator.pop(context);
    }
  }
}


