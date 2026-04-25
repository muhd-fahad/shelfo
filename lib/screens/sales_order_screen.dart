import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Sales Order"),
      ),
      body: const Center(
        child: Text("Sales order screen"),
      ),
    );
  }
}
