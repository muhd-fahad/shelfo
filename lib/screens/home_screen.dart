import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SFOLogo(
          height: 24,
          fit: BoxFit.fitWidth,
        ),
        actions: [
          Row(
            children: [
              IconButton(onPressed:  () => Navigator.pushNamed(context,  AppRoutes.notification), icon: const Icon(Icons.notifications_none_rounded, size: 24)),
              IconButton(onPressed: () => Navigator.pushNamed(context, AppRoutes.settings), icon: const Icon(Icons.account_circle_outlined, size: 24)),
            ],
          )
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Placeholder(
                child: Center(child: Text("Quick info cards")),
              ),
            ),
            Text("Whereas disregard and contempt for human rights have resulted"),
          ],
        ),
      ),
    );
  }
}
