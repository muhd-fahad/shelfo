import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';
class PolicyScreen extends StatelessWidget {
  const PolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Policies & Warranties"),
      ),
      body: Center(
        child: Text("policy screen"),
      ),
    );
  }
}
