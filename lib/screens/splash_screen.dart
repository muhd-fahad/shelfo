import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shelfo/routes/app_routes.dart';

import '../widgets/splash/stack_cards_splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _splash();
  }

  void _splash() async {
    await Future.delayed(Duration(seconds: 3));

    // --- THIS IS THE FIX Async Gaps ---
    if (!mounted) return;
    // -----------------------

    // Now it is safe to use context
    Navigator.pushReplacementNamed(context, AppRoutes.businessInfo);
    debugPrint("Splash");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Row(
                spacing: 8,
                mainAxisSize: .max,
                crossAxisAlignment: .center,
                mainAxisAlignment: .center,
                children: [
                  SvgPicture.asset("assets/logo/app_logo_Primary.svg",height: 48,fit: BoxFit.fitWidth,)
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
