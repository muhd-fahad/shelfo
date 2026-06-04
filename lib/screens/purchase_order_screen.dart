import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';
import '../widgets/sfo_common/sfo_background.dart';

class PurchaseOrderScreen extends StatelessWidget {
  const PurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SFOHeader(title: "Purchase Orders"),
      body: SFOBackground(
        child: Center(
          child: Text("Purchase order screen"),
        ),
      ),
    );
  }
}
