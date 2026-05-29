import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../models/purchase/purchase_order_model.dart';
import '../../../provider/purchase_order_provider.dart';
import '../../../provider/purchase_order_form_provider.dart';
import '../../../provider/vendor_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../models/product/product_model.dart';
import '../../../widgets/sfo_common/sfo_background.dart';
import '../../../widgets/sfo_common/sfo_header.dart';
import '../../../widgets/sfo_common/sfo_input_field.dart';
import '../../../widgets/sfo_common/sfo_button.dart';
import '../../../widgets/sfo_common/sfo_dropdown.dart';
import '../../../widgets/sfo_common/sfo_card.dart';

class NewPurchaseOrderScreen extends StatelessWidget {
  final PurchaseOrder? order;
  const NewPurchaseOrderScreen({super.key, this.order});

  @override
  Widget build(BuildContext context) {
    final vendors = context.read<VendorProvider>().vendors;
    return ChangeNotifierProvider(
      create: (_) => PurchaseOrderFormProvider(originalOrder: order, vendors: vendors),
      child: const _NewPurchaseOrderContent(),
    );
  }
}

class _NewPurchaseOrderContent extends StatelessWidget {
  const _NewPurchaseOrderContent();

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formProvider = context.watch<PurchaseOrderFormProvider>();
    final poProvider = context.read<PurchaseOrderProvider>();
    final vendorProvider = context.watch<VendorProvider>();
    final productProvider = context.watch<ProductProvider>();

    return Scaffold(
      appBar: AppBar(
        title: SFOHeader(title: formProvider.isEditing ? "Edit Purchase Order" : "New Purchase Order"),
      ),
      body: SFOBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.r),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SFOCard(
                  padding: EdgeInsets.all(16.r),
                  children: [
                    SFODropdown<String>(
                      label: "Vendor",
                      isRequired: true,
                      value: formProvider.selectedVendor?.id,
                      items: vendorProvider.vendors
                          .map((v) => DropdownMenuItem(value: v.id, child: Text(v.companyName)))
                          .toList(),
                      onChanged: (id) {
                        final vendor = vendorProvider.vendors.firstWhere((v) => v.id == id);
                        formProvider.setVendor(vendor);
                      },
                      hint: "Select vendor...",
                    ),
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: formProvider.expectedDate ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );
                        formProvider.setExpectedDate(date);
                      },
                      child: AbsorbPointer(
                        child: SFOInputField(
                          label: "Expected Date",
                          controller: TextEditingController(
                            text: formProvider.expectedDate == null
                                ? ""
                                : DateFormat('MM/dd/yyyy').format(formProvider.expectedDate!),
                          ),
                          hint: "mm/dd/yyyy",
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    SFOInputField(
                      label: "Notes",
                      controller: formProvider.notesController,
                      hint: "Enter notes here...",
                      maxLines: 3,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                SFOCard(
                  padding: EdgeInsets.all(16.r),
                  children: [
                    Text("Add Items", style: Theme.of(context).textTheme.titleSmall),
                    SizedBox(height: 12.h),
                    SFODropdown<Product>(
                      label: "Product",
                      value: formProvider.selectedProduct,
                      items: productProvider.products
                          .map((p) => DropdownMenuItem(value: p, child: Text(p.name)))
                          .toList(),
                      onChanged: formProvider.setProduct,
                      hint: "Select product...",
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: SFOInputField(
                            label: "Quantity",
                            controller: formProvider.quantityController,
                            hint: "1",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: SFOInputField(
                            label: "Cost Price",
                            controller: formProvider.costController,
                            hint: "0",
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    SFOButton(
                      text: "+ Add Item",
                      onPressed: formProvider.addItem,
                      width: double.infinity,
                      type: SFOButtonType.outlined,
                    ),
                    if (formProvider.items.isNotEmpty) ...[
                      SizedBox(height: 16.h),
                      const Divider(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: formProvider.items.length,
                        itemBuilder: (context, index) {
                          final item = formProvider.items[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(item.productName),
                            subtitle: Text("${item.quantity} x ₹ ${item.costPrice}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => formProvider.removeItem(index),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 24.h),
                SFOButton(
                  text: formProvider.isEditing ? "Save Changes" : "Create Purchase Order",
                  onPressed: formProvider.selectedVendor == null || formProvider.items.isEmpty
                      ? null
                      : () {
                          if (formProvider.isEditing) {
                            poProvider.updateOrderFromForm(formProvider);
                          } else {
                            poProvider.addOrderFromForm(formProvider);
                          }
                          Navigator.pop(context);
                        },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
