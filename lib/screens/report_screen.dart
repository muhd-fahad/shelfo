import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';
import '../widgets/sfo_common/sfo_background.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Reports & Analysis"),
      ),
      body: const SFOBackground(
        child: Center(child: Text("Report screen")),
      ),
    );
  }
}
