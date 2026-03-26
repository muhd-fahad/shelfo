import 'package:flutter/material.dart';

import '../../utils/theme/theme.dart';
import '../../widgets/screen_title_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Settings"),
      ),
      body: Center(
        child: Text("Settings"),
      ),
    );
  }
}
