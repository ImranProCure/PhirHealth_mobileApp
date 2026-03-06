import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceScanView extends StatelessWidget {
  const FaceScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002F2B), // prevents white flash
      body: GestureDetector(
        onTap: () => Get.toNamed('/scan-report'),
        child: SizedBox.expand(
          child: Image.asset(
            'assets/PHIR Health - PHIR Face Scan 1.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(
              child: Icon(
                Icons.face,
                size: 80,
                color: Colors.white54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}