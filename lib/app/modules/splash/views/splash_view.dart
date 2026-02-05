import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart'; // Get package add kiya
import '../../home/views/home_view.dart';
import '../../home/bindings/home_binding.dart'; // Binding import karna zaroori hai

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // Full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Timer Logic
    Future.delayed(const Duration(seconds: 3), () {
      // Check if widget is mounted (active)
      // Note: GetX use karte waqt 'mounted' check karna optional hota hai,
      // par safety ke liye rakh sakte hain.

      // Navigate to Home with Binding
      Get.off(
        () => const HomeView(),
        binding:
            HomeBinding(), // <-- YEH MAIN CHANGE HAI (Controller Load karega)
      );
    });
  }

  @override
  void dispose() {
    // Wapas normal screen mode
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover),
          ),

          // Logo in Center
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(30.0),
              child: Image.asset('assets/logo.png', fit: BoxFit.contain),
            ),
          ),
        ],
      ),
    );
  }
}
