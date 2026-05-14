import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';
import '../widgets/sfo_common/sfo_background.dart';

class PurchaseOrderScreen extends StatelessWidget {
  const PurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Purchase Orders"),
      ),
      body: const SFOBackground(
        child: Center(
          child: Text("Purchase order screen"),
        ),
      ),
    );
  }
}
