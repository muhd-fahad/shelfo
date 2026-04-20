import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Reports & Analysis"),
      ),
      body: const Center(child: Text("Report screen")),
    );
  }
}
