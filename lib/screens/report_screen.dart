import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';
import '../widgets/sfo_common/sfo_background.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SFOHeader(title: "Reports & Analysis"),
      body: SFOBackground(
        child: Center(child: Text("Report screen")),
      ),
    );
  }
}
