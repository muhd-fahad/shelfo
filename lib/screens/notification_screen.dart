import 'package:flutter/material.dart';

import '../widgets/screen_title_widget.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ScreenTitleWidget("Notifications"),
      ),
      body: Center(
        child: Text("Notification screen"),
      ),
    );
  }
}