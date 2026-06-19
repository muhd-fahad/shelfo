import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/splash/splash_provider.dart';
import 'package:shelfo/widgets/sfo_common/sfo_logo.dart';
import '../../widgets/splash/stack_cards_splash.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger initialization logic via Provider
    // Using context.read because we only want to call it once without rebuilding on change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashProvider>().init();
    });

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SFOLogo(
                    height: 48.h,
                    fit: BoxFit.fitWidth,
                  )
                ],
              ),
            ),
            const CardStacksSplash(),
          ],
        ),
      ),
    );
  }
}
