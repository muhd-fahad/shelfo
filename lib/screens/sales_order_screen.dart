import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';

class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Sales Order"),
      ),
      body: Center(
        child: Text("Sales order screen"),
      ),
    );
  }
}
