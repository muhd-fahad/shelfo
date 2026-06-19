import 'package:flutter/material.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/services/hive/settings_service.dart';
import 'package:shelfo/services/notification/local_notification_service.dart';

class SplashProvider extends ChangeNotifier {
  bool _isInitialized = false;

  void init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await Future.delayed(const Duration(seconds: 3));

    try {
      final isOnboarded = await SettingsHiveService.isOnboarded();
      final navigator = LocalNotificationService.navigatorKey.currentState;

      if (navigator != null) {
        if (isOnboarded) {
          navigator.pushReplacementNamed(AppRoutes.bottomNavbar);
        } else {
          navigator.pushReplacementNamed(AppRoutes.businessInfo);
        }
      }
    } catch (e) {
      debugPrint("Error in SplashProvider: $e");
      LocalNotificationService.navigatorKey.currentState
          ?.pushReplacementNamed(AppRoutes.businessInfo);
    }
  }
}
