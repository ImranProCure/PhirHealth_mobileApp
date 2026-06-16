// face_scan_controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FaceScanController extends GetxController {
  CameraController? cameraController;

  final isScanning = false.obs;
  final scanProgress = 0.0.obs;
  final faceDetected = false.obs;

  static const int sampleSeconds = 30;
  static const Duration captureInterval = Duration(seconds: 1);

  final List<String> _frames = []; // base64-encoded jpg frames
  int _secondsLeft = sampleSeconds;

  Timer? _countdownTimer;
  Timer? _captureTimer;

  @override
  void onInit() {
    super.onInit();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    cameraController = CameraController(
      front,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await cameraController!.initialize();
    try {
      await cameraController!.setFocusMode(FocusMode.auto);
    } catch (_) {}
    update();
  }

  void startScan() {
    if (isScanning.value ||
        cameraController == null ||
        !cameraController!.value.isInitialized) {
      return;
    }

    _frames.clear();
    _secondsLeft = sampleSeconds;
    isScanning.value = true;
    scanProgress.value = 0.0;
    faceDetected.value = true;

    // Capture first frame immediately
    _captureFrame();

    _captureTimer = Timer.periodic(captureInterval, (_) {
      _captureFrame();
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsLeft--;
      scanProgress.value =
          ((sampleSeconds - _secondsLeft) / sampleSeconds).clamp(0.0, 1.0);

      if (_secondsLeft <= 0) {
        timer.cancel();
        _completeScan();
      }
    });
  }

  Future<void> _captureFrame() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }
    if (cameraController!.value.isTakingPicture) return;

    try {
      final XFile file = await cameraController!.takePicture();
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      _frames.add(base64Image);

      // Clean up temp file
      try {
        await File(file.path).delete();
      } catch (_) {}
    } catch (e) {
      debugPrint('Frame capture error: $e');
    }
  }

  Future<void> _completeScan() async {
    _captureTimer?.cancel();
    _countdownTimer?.cancel();

    final result = await _sendFramesToApi();
    isScanning.value = false;
    scanProgress.value = 1.0;
    Get.toNamed('/scan-report', arguments: result);
  }

  Future<Map<String, dynamic>> _sendFramesToApi() async {
    try {
      final response = await http.post(
        Uri.parse('https://overnight-nest-bacteria.ngrok-free.dev/scan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'frames': _frames,
          'duration': sampleSeconds,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return data;
      } else {
        return _fallbackResult();
      }
    } catch (_) {
      return _fallbackResult();
    }
  }

  Map<String, dynamic> _fallbackResult() {
    return {
      'wellnessScore': 0,
      'vitals': [
        {
          'value': '--',
          'unit': 'bpm',
          'label': 'Heart Rate',
          'imagePath': 'assets/icons/favorite.png',
          'iconBg': 0xFFFFF0F0
        },
        {
          'value': '--',
          'unit': 'ms',
          'label': 'HRV (RMSSD)',
          'imagePath': 'assets/icons/Group 217-1.png',
          'iconBg': 0xFFEFF6FF
        },
        {
          'value': '--',
          'unit': '',
          'label': 'Stress Level',
          'imagePath': 'assets/icons/Group 217.png',
          'iconBg': 0xFFFFF8E1,
          'valueLarge': true
        },
        {
          'value': '--',
          'unit': '/min',
          'label': 'Respiration',
          'imagePath': 'assets/icons/Group 217-2.png',
          'iconBg': 0xFFE0F2F1
        },
      ],
      'aiInsight':
          'Could not reach the analysis server or scan was too short. Please try again with better lighting.',
      'status': 'Scan Failed',
    };
  }

  @override
  void onClose() {
    _captureTimer?.cancel();
    _countdownTimer?.cancel();
    cameraController?.dispose();
    super.onClose();
  }
}
