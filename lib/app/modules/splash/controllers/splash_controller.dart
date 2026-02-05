import 'package:flutter/material.dart';
import '../../home/views/home_view.dart';

class SplashController {
  void startSplashTimer(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      }
    });
  }
}
