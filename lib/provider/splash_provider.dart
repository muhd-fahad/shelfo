import 'package:flutter/material.dart';

class SplashProvider extends ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

// Simulate a startup task (e.g., checking a login token)
  Future<void> initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Mock delay
    _isInitialized = true;
    notifyListeners();
  }
}
