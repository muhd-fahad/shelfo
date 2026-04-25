import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "POS"),
      ),
      body: const Center(
        child: Text("POS screen"),
      ),
    );
  }
}
