import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/models/currency/currency.dart';
import 'package:shelfo/models/product/product_model.dart';
import 'package:shelfo/models/sale/sale_model.dart';
import 'package:shelfo/models/customer/customer_model.dart';
import 'package:shelfo/utils/formatters/currency_formatter.dart';
import 'package:shelfo/utils/theme/theme.dart';
import 'package:shelfo/widgets/sfo_common/sfo_background.dart';
import 'package:shelfo/widgets/sfo_common/sfo_button.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';
import 'package:shelfo/widgets/sfo_common/sfo_dropdown.dart';
import 'package:shelfo/widgets/sfo_common/sfo_selection_field.dart';
import 'package:shelfo/widgets/inventory/product_selection_sheet.dart';
import 'package:shelfo/widgets/sfo_common/sfo_input_field.dart';
import 'package:shelfo/widgets/sfo_common/sfo_section_header.dart';
import 'package:shelfo/widgets/sfo_common/sfo_bottom_sheet.dart';
import 'package:shelfo/widgets/customer/customer_selection_sheet.dart';

import 'package:shelfo/widgets/sfo_common/sfo_responsive.dart';
import '../../provider/business/business_provider.dart';
import '../../provider/business/tax_provider.dart';
import '../../provider/customer/customer_provider.dart';
import '../../provider/inventory/product_provider.dart';
import '../../provider/sales/invoice_form_provider.dart';
import '../../provider/sales/sale_provider.dart';
import '../../widgets/sfo_common/sfo_header.dart';

class InvoiceFormScreen extends StatelessWidget {
  final Sale? invoice;
  const InvoiceFormScreen({super.key, this.invoice});

  @override
  Widget build(BuildContext context) {
    final taxProvider = context.watch<TaxProvider>();
    final customerProvider = context.read<CustomerProvider>();

    if (taxProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => InvoiceFormProvider(
        invoice,
        isTaxEnabled: taxProvider.isTaxEnabled,
        taxRate: double.tryParse(taxProvider.taxRateController.text) ?? 0.0,
        taxLabel: taxProvider.taxLabelController.text,
        pricingMode: taxProvider.pricingMode,
        allCustomers: customerProvider.customers,
      ),
      child: const _InvoiceFormContent(),
    );
  }
}

class _InvoiceFormContent extends StatelessWidget {
  const _InvoiceFormContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formProvider = context.watch<InvoiceFormProvider>();
    final productProvider = context.watch<ProductProvider>();
    final saleProvider = context.read<SaleProvider>();
    final businessProvider = context.watch<BusinessProvider>();
    final currency = businessProvider.selectedCurrency;
    
    final isEditing = formProvider.isEditing;

    return Scaffold(
      appBar: SFOHeader(
        title: isEditing ? "Edit Invoice" : "New Invoice",
      ),
      body: SFOBackground(
        child: SFOResponsive(
          mobile: _buildContent(context, formProvider, productProvider, saleProvider, theme, currency, isEditing),
          desktop: SFOResponsive.constrained(
            _buildContent(context, formProvider, productProvider, saleProvider, theme, currency, isEditing),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    InvoiceFormProvider formProvider,
    ProductProvider productProvider,
    SaleProvider saleProvider,
    ThemeData theme,
    Currency currency,
    bool isEditing,
  ) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: [
              const SFOSectionHeader(title: "Invoice Details"),
              SizedBox(height: 16.h),

              // Customer Selection via Sheet
              GestureDetector(
                onTap: () async {
                  context.read<CustomerProvider>().setSearchQuery(""); // Clear search
                  final customer = await SFOBottomSheet.show<Customer>(
                    context,
                    title: "Select Customer",
                    child: const CustomerSelectionSheet(),
                  );
                  if (customer != null) {
                    formProvider.setCustomer(customer);
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: theme.inputDecorationTheme.fillColor,
                    borderRadius: AppRadius.md,
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: theme.colorScheme.primary),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formProvider.selectedCustomer?.name ?? "Select Customer",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: formProvider.selectedCustomer != null ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            if (formProvider.selectedCustomer != null) ...[
                              SizedBox(height: 4.h),
                              Text(
                                "${formProvider.selectedCustomer?.phone ?? 'No Phone'} • ${formProvider.selectedCustomer?.address ?? 'No Address'}",
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_right, color: theme.colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              SFODropdown<String>(
                label: "Payment Method",
                value: formProvider.paymentMethod,
                items: ["Cash", "Card", "Bank Transfer", "E-Wallet"]
                    .map((m) => DropdownMenuItem(
                          value: m,
                          child: Text(m),
                        ))
                    .toList(),
                onChanged: (val) => formProvider.setPaymentMethod(val!),
              ),
              SizedBox(height: 16.h),
              SFOInputField(
                label: "Notes",
                hint: "Optional notes...",
                controller: formProvider.notesController,
                maxLines: 3,
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SFOCard(
            padding: EdgeInsets.all(16.r),
            children: [
              const SFOSectionHeader(title: "Add Items"),
              SizedBox(height: 16.h),
              SFOSelectionField(
                label: "Select product",
                value: formProvider.selectedProduct?.name,
                hint: "Select product...",
                onTap: () async {
                  final product = await SFOBottomSheet.show<Product>(
                    context,
                    title: "Select Product",
                    child: const ProductSelectionSheet(),
                  );
                  if (product != null) {
                    formProvider.setProduct(product);
                  }
                },
              ),
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SFOInputField(
                      label: "Quantity",
                      hint: "1",
                      controller: formProvider.quantityController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  SFOButton(
                    text: "Add Item",
                    width: 100.w,
                    onPressed: formProvider.selectedProduct == null ? null : formProvider.addItem,
                  ),
                ],
              ),
              if (formProvider.items.isNotEmpty) ...[
                SizedBox(height: 24.h),
                const Divider(),
                SizedBox(height: 16.h),
                ...formProvider.items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.productName, style: theme.textTheme.titleSmall),
                              Text("${item.quantity} x ${CurrencyFormatter.format(item.price, currency)}", style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Text(CurrencyFormatter.format(item.total, currency), style: theme.textTheme.titleSmall),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                          onPressed: () => formProvider.removeItem(index),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(),
                _buildPriceRow("Subtotal", formProvider.subtotal, currency, theme),
                _buildPriceRow("${formProvider.taxLabel} (${formProvider.taxRate}%)", formProvider.taxAmount, currency, theme),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        CurrencyFormatter.format(formProvider.total, currency),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.success),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 32.h),
          SFOButton(
            text: isEditing ? "Update Invoice" : "Create Invoice",
            onPressed: (formProvider.selectedCustomer == null || formProvider.items.isEmpty)
                ? null
                : () async {
                    String invoiceId;
                    if (isEditing) {
                      invoiceId = formProvider.originalInvoice!.id;
                    } else {
                      invoiceId = await saleProvider.getNextInvoiceId();
                    }

                    final saleToSave = Sale(
                      id: invoiceId,
                      dateTime: isEditing ? formProvider.originalInvoice!.dateTime : DateTime.now(),
                      customerName: formProvider.selectedCustomer!.name,
                      items: formProvider.items,
                      subtotal: formProvider.subtotal,
                      taxAmount: formProvider.taxAmount,
                      total: formProvider.total,
                      paymentMethod: formProvider.paymentMethod,
                      status: isEditing ? formProvider.originalInvoice!.status : 'Paid',
                      notes: formProvider.notesController.text.isNotEmpty ? formProvider.notesController.text : null,
                    );

                    if (isEditing) {
                      await saleProvider.updateSale(saleToSave);
                    } else {
                      await saleProvider.addSale(saleToSave, productProvider: productProvider);
                    }
                    Navigator.pop(context);
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, Currency currency, ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(CurrencyFormatter.format(amount, currency), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
