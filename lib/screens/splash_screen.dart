import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shelfo/routes/app_routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _splash(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));

    // --- THIS IS THE FIX Async Gaps ---
    if (!context.mounted) return;
    // -----------------------

    Navigator.pushReplacementNamed(context, AppRoutes.businessInfo);
  }

  @override
  Widget build(BuildContext context) {
    _splash(context);
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
                  SvgPicture.asset(
                    "assets/logo/app_logo_Primary.svg",
                    height: 48,
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 70),
                decoration: ShapeDecoration(
                  color: const Color(0x4C16A34A),
                  shape: RoundedSuperellipseBorder(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.only(top: 70),
                  decoration: ShapeDecoration(
                    color: const Color(0x7F16A34A),
                    shape: RoundedSuperellipseBorder(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 70),
                    decoration: ShapeDecoration(
                      color: const Color(0xB216A34A),
                      shape: RoundedSuperellipseBorder(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
