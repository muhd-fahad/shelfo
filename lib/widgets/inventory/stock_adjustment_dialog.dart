import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product/product_model.dart';
import '../../provider/product_provider.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_input_field.dart';

class StockAdjustmentDialog extends StatelessWidget {
  final Product product;
  final bool isAddition;

  const StockAdjustmentDialog({
    super.key,
    required this.product,
    required this.isAddition,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<ProductProvider>();

    return Dialog(
      shape: const RoundedSuperellipseBorder(borderRadius: AppRadius.xl),
      backgroundColor: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isAddition ? "Add Stock" : "Remove Stock",
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SFOInputField(
              label: "Quantity *",
              hint: "0",
              controller: provider.adjustmentQuantityController,
              keyboardType: TextInputType.number,
            ),
            if (isAddition) ...[
              const SizedBox(height: 16),
              SFOInputField(
                label: "Cost Per Unit",
                hint: "0.00",
                controller: provider.adjustmentCostController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
            const SizedBox(height: 16),
            SFOInputField(
              label: "Notes",
              hint: "Optional",
              controller: provider.adjustmentNotesController,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SFOButton(
              text: isAddition ? "Confirm Add Stock" : "Confirm Remove",
              onPressed: () {
                final qty = int.tryParse(provider.adjustmentQuantityController.text) ?? 0;
                final cost = double.tryParse(provider.adjustmentCostController.text);
                
                provider.adjustStock(
                  product, 
                  qty, 
                  isAddition: isAddition,
                  newCostPrice: isAddition ? cost : null,
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
