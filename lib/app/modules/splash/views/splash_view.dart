import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sample/app/routes/app_routes.dart';
import 'package:sample/app/service/api/api_client/api_client.dart';
import 'package:sample/app/service/db/db.dart';
import '../../home/views/home_view.dart';
import '../../home/bindings/home_binding.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool _navigated = false; // ✅ GUARD FLAG

  @override
  void initState() {
    super.initState();

    // Full screen mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(const Duration(seconds: 3), () {
      // ✅ PREVENT MULTIPLE NAVIGATION
      if (_navigated || !mounted) return;
      _navigated = true;

      _initializeApp();
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  Future<void> _initializeApp() async {
    final authStorage = AuthStorageService();

    final apiClient = ApiClient();

    await apiClient.initializeToken();

    final loginStatus = await authStorage.getLoginStatus();

    if (!loginStatus) {
      Get.off(
        () => const HomeView(),
        binding: HomeBinding(),
      );

      return;
    }

    final role = authStorage.getRole();

    if (role == "doctor") {
      Get.offAllNamed(Routes.DOCTOR_DASHBOARD);
    } else {
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
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
              padding: const EdgeInsets.all(30),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
