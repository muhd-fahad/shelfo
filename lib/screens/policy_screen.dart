import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Policies & Warranties"),
      ),
      body: const Center(
        child: Text("policy screen"),
      ),
    );
  }
}
