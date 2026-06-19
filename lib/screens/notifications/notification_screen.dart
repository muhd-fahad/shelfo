import 'package:flutter/material.dart';
import 'package:shelfo/widgets/sfo_common/sfo_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SFOHeader(title: "Notifications"),
      body: Center(
        child: Text("Notification screen"),
      ),
    );
  }
}
