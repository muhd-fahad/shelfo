import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("POS"),
      ),
      body: Center(
        child: Text("POS screen"),
      ),
    );
  }
}
