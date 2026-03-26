import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Inventory"),
      ),
      body: Center(
        child: Text("Inventory screen"),
      ),
    );
  }
}
