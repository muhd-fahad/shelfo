import 'package:flutter/material.dart';
import '../widgets/sfo_common/sfo_header.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOHeader(title: "Notifications"),
      ),
      body: const Center(
        child: Text("Notification screen"),
      ),
    );
  }
}
