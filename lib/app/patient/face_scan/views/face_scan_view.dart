import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceScanView extends StatelessWidget {
  const FaceScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed('/scan-report'),
      child: Scaffold(
        body: SizedBox.expand(
          child: Image.asset(
            'assets/PHIR Health - PHIR Face Scan 1.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF0D2137),
              child: const Center(
                child: Icon(Icons.face, size: 80, color: Colors.white54),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
