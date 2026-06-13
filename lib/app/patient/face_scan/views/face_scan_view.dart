// face_scan_view.dart
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sample/app/patient/scan_report/controllers/face_scan_controller.dart';

class FaceScanView extends GetView<FaceScanController> {
  const FaceScanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF002F2B),
      body: Obx(() {
        final cam = controller.cameraController;
        final scanning = controller.isScanning.value;
        return Stack(
          fit: StackFit.expand,
          children: [
            // Camera preview - only after scan starts
            if (scanning && cam != null && cam.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: cam.value.previewSize!.height,
                    height: cam.value.previewSize!.width,
                    child: CameraPreview(cam),
                  ),
                ),
              ),
            // Face frame border - only while scanning
            if (scanning)
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: controller.faceDetected.value
                          ? const Color(0xFF00897B)
                          : Colors.white54,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: Center(
                      child: SizedBox(
                        child: Lottie.asset(
                          'assets/animations/faceik.json',
                          fit: BoxFit.contain,
                          repeat: true,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Lottie animation - only before scan starts
            if (!scanning)
              Center(
                child: SizedBox(
                  height: 400,
                  child: Lottie.asset(
                    'assets/animations/face_scan.json',
                    fit: BoxFit.contain,
                    repeat: true,
                  ),
                ),
              ),

            Positioned(
              bottom: 80,
              left: 24,
              right: 24,
              child: Column(
                children: [
                  if (scanning) ...[
                    Text(
                      controller.faceDetected.value
                          ? 'Scanning... ${(controller.scanProgress.value * 100).toInt()}%'
                          : 'Face not detected — center your face',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Mulish',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: controller.scanProgress.value,
                      backgroundColor: Colors.white24,
                      color: const Color(0xFF00897B),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Hold still and keep your face well-lit',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Mulish'),
                    ),
                  ] else ...[
                    const Text(
                      'Position your face within the frame',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish',
                          fontSize: 15),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.startScan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00897B),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text(
                          'Start Scans',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Wellness estimate only — not a medical device',
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 11,
                          fontFamily: 'Mulish'),
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
