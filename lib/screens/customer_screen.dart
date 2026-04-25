import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Customers"),
      ),
      body: const Center(
        child: Text("Customer screen"),
      ),
    );
  }
}
