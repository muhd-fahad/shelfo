import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';
import '../widgets/sfo_common/sfo_background.dart';

class SalesOrderScreen extends StatelessWidget {
  const SalesOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SFOHeader(title: "Sales Order"),
      body: SFOBackground(
        child: Center(
          child: Text("Sales order screen"),
        ),
      ),
    );
  }
}
