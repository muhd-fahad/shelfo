import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';

class PurchaseOrderScreen extends StatelessWidget {
  const PurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Purchase Orders"),
      ),
      body: Center(
        child: Text("Purchase order screen"),
      ),
    );
  }
}
