import 'package:flutter/material.dart';
import '../../models/product/product_model.dart';
import '../../provider/product_provider.dart';
import '../../utils/theme/theme.dart';
import '../sfo_common/sfo_button.dart';
import '../sfo_common/sfo_input_field.dart';

class StockAdjustmentDialog extends StatefulWidget {
  final Product product;
  final ProductProvider provider;
  final bool isAddition;

  const StockAdjustmentDialog({
    super.key,
    required this.product,
    required this.provider,
    required this.isAddition,
  });

  @override
  State<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<StockAdjustmentDialog> {
  late TextEditingController _quantityController;
  late TextEditingController _costController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(text: "1");
    _costController = TextEditingController(text: widget.product.costPrice.toString());
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  widget.isAddition ? "Add Stock" : "Remove Stock",
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
              controller: _quantityController,
              keyboardType: TextInputType.number,
            ),
            if (widget.isAddition) ...[
              const SizedBox(height: 16),
              SFOInputField(
                label: "Cost Per Unit",
                hint: "0.00",
                controller: _costController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
            const SizedBox(height: 16),
            SFOInputField(
              label: "Notes",
              hint: "Optional",
              controller: _notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SFOButton(
              text: widget.isAddition ? "Confirm Add Stock" : "Confirm Remove",
              onPressed: () {
                final qty = int.tryParse(_quantityController.text) ?? 0;
                final cost = double.tryParse(_costController.text);
                
                widget.provider.adjustStock(
                  widget.product, 
                  qty, 
                  isAddition: widget.isAddition,
                  newCostPrice: widget.isAddition ? cost : null,
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
