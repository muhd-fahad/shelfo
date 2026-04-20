import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';
class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Customers"),
      ),
      body: Center(
        child: Text("Customer screen"),
      ),
    );
  }
}
