import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';

import '../widgets/splash/stack_cards_splash.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _splash(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.businessInfo);
    debugPrint("Splash");
  }

  @override
  Widget build(BuildContext context) {
    _splash(context);

    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SFOLogo(
                    height: 48,
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
            ),
            CardStacksSplash(),
          ],
        ),
      ),
    );
  }
}
