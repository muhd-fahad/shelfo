import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SFOHeader(title: "Customers"),
      body: Center(
        child: Text("Customer screen"),
      ),
    );
  }
}
