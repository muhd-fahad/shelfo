import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class PurchaseOrderScreen extends StatelessWidget {
  const PurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Purchase Orders"),
      ),
      body: const Center(
        child: Text("Purchase order screen"),
      ),
    );
  }
}
