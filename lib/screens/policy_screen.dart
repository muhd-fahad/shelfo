import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SFOHeader(title: "Policies & Warranties"),
      body: Center(
        child: Text("policy screen"),
      ),
    );
  }
}
