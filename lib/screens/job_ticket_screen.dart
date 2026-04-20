import 'package:flutter/material.dart';

class JobTicketScreen extends StatelessWidget {
  const JobTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Service Jobs"),
      ),
      body: Center(
        child: Text("Service and Jobs screen"),
      ),
    );
  }
}
