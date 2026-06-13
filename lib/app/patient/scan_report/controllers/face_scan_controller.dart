// face_scan_controller.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:fftea/fftea.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceScanController extends GetxController {
  CameraController? cameraController;
  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(performanceMode: FaceDetectorMode.fast),
  );

  final isScanning = false.obs;
  final scanProgress = 0.0.obs;
  final faceDetected = false.obs;

  final List<double> _signal = [];
  final List<double> _timestamps = [];
  static const int sampleSeconds = 25;
  bool _processing = false;

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
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    await cameraController!.initialize();
    try {
      await cameraController!.setFocusMode(FocusMode.auto);
    } catch (_) {}
    update();
  }

  void startScan() {
    if (isScanning.value || cameraController == null) return;
    _signal.clear();
    _timestamps.clear();
    isScanning.value = true;
    scanProgress.value = 0.0;

    final startTime = DateTime.now();

    cameraController!.startImageStream((CameraImage image) async {
      if (_processing) return;
      _processing = true;

      try {
        final faces = await faceDetector.processImage(_toInputImage(image));
        if (faces.isNotEmpty) {
          faceDetected.value = true;
          final box = faces.first.boundingBox;
          final luma = _extractForeheadLuma(image, box);

          final elapsed =
              DateTime.now().difference(startTime).inMilliseconds / 1000.0;
          _signal.add(luma);
          _timestamps.add(elapsed);
          scanProgress.value = (elapsed / sampleSeconds).clamp(0.0, 1.0);

          if (elapsed >= sampleSeconds) {
            await cameraController!.stopImageStream();
            isScanning.value = false;
            _finishScan();
          }
        } else {
          faceDetected.value = false;
        }
      } catch (e) {
        // ignore malformed frame
      } finally {
        _processing = false;
      }
    });
  }

  InputImage _toInputImage(CameraImage image) {
    final camera = cameraController!.description;
    final rotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;

    if (Platform.isAndroid) {
      final WriteBuffer allBytes = WriteBuffer();
      for (final plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      return InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.nv21,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );
    } else {
      final plane = image.planes.first;
      return InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: InputImageFormat.bgra8888,
          bytesPerRow: plane.bytesPerRow,
        ),
      );
    }
  }

  double _extractForeheadLuma(CameraImage image, Rect box) {
    final yPlane = image.planes[0];
    final bytes = yPlane.bytes;
    final width = image.width;
    final height = image.height;
    final bytesPerRow = yPlane.bytesPerRow;

    final left = box.left.clamp(0, width.toDouble()).toInt();
    final top = box.top.clamp(0, height.toDouble()).toInt();
    final right = box.right.clamp(0, width.toDouble()).toInt();
    final bottom = box.bottom.clamp(0, height.toDouble()).toInt();
    if (right <= left || bottom <= top) return 0.0;

    final roiTop = top;
    final roiBottom = top + ((bottom - top) * 0.35).toInt();
    final roiLeft = left + ((right - left) * 0.25).toInt();
    final roiRight = right - ((right - left) * 0.25).toInt();

    int sum = 0, count = 0;
    for (int y = roiTop; y < roiBottom; y += 2) {
      for (int x = roiLeft; x < roiRight; x += 2) {
        final idx = y * bytesPerRow + x;
        if (idx >= 0 && idx < bytes.length) {
          sum += bytes[idx];
          count++;
        }
      }
    }
    return count > 0 ? sum / count : 0.0;
  }

  void _finishScan() {
    final result = _computeVitals();
    Get.toNamed('/scan-report', arguments: result);
  }

  Map<String, dynamic> _computeVitals() {
    if (_signal.length < 50) {
      return _fallbackResult();
    }

    const targetFps = 30.0;
    final duration = _timestamps.last;
    final numSamples = (duration * targetFps).toInt();
    final resampled = _resample(_signal, _timestamps, numSamples, targetFps);
    final detrended = _detrend(resampled);
    final windowed = _applyHamming(detrended);

    final filteredSignal = _bandpassFilter(windowed, targetFps, 0.7, 4.0);
    final bpm = _dominantBpm(windowed, targetFps, 0.7, 4.0);
    final hrv = _computeHRV(filteredSignal, targetFps);
    final respRate = _dominantBpm(detrended, targetFps, 0.15,
        0.4); // Hz->per-min via same fn (returns *60)

    final heartRate = bpm.round().clamp(40, 180);
    final respiration = (respRate / 4).round().clamp(8, 30);

    final hrvRounded = hrv.round().clamp(0, 200);

    final stress = heartRate > 95
        ? 'Elevated'
        : heartRate < 60
            ? 'Low'
            : 'Normal';

    int wellnessScore = 100;
    if (heartRate > 90 || heartRate < 60) wellnessScore -= 10;
    if (stress == 'Elevated') wellnessScore -= 15;
    if (respiration > 20 || respiration < 12) wellnessScore -= 5;

    wellnessScore = wellnessScore.clamp(0, 100);

    final vitals = [
      {
        'value': heartRate.toString(),
        'unit': 'bpm',
        'label': 'Heart Rate',
        'imagePath': 'assets/icons/favorite.png',
        'iconBg': 0xFFFFF0F0,
      },
      {
        'value': hrvRounded.toString(),
        'unit': 'ms',
        'label': 'HRV (RMSSD)',
        'imagePath': 'assets/icons/Group 217-1.png',
        'iconBg': 0xFFEFF6FF,
      },
      {
        'value': stress,
        'unit': '',
        'label': 'Stress Level',
        'imagePath': 'assets/icons/Group 217.png',
        'iconBg': 0xFFFFF8E1,
        'valueLarge': true,
      },
      {
        'value': respiration.toString(),
        'unit': '/min',
        'label': 'Respiration',
        'imagePath': 'assets/icons/Group 217-2.png',
        'iconBg': 0xFFE0F2F1,
      },
    ];

    String aiInsight;
    if (stress == 'Elevated') {
      aiInsight =
          'Your heart rate reading is elevated. Try a 5-minute breathing exercise and rescan when relaxed.';
    } else if (heartRate < 55) {
      aiInsight =
          'Your reading is on the lower side. If this seems off, rescan with better lighting and a still face.';
    } else if (hrvRounded < 20) {
      aiInsight =
          'Your HRV is on the lower side, which can indicate fatigue or stress. Consider rest and recovery.';
    } else {
      aiInsight =
          'Your heart rate and HRV look within a normal range based on this scan.';
    }

    return {
      'wellnessScore': wellnessScore,
      'vitals': vitals,
      'aiInsight': aiInsight,
      'status': wellnessScore >= 70 ? 'Good Status' : 'Needs Attention',
    };
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
          'Scan was too short or face was not detected consistently. Please try again with better lighting.',
      'status': 'Scan Failed',
    };
  }

  // ---- Signal processing helpers ----

  List<double> _resample(
      List<double> signal, List<double> times, int n, double fps) {
    final result = List<double>.filled(n, 0.0);
    for (int i = 0; i < n; i++) {
      final t = i / fps;
      int j = 0;
      while (j < times.length - 1 && times[j + 1] < t) {
        j++;
      }
      if (j >= times.length - 1) {
        result[i] = signal.last;
      } else {
        final t0 = times[j], t1 = times[j + 1];
        final s0 = signal[j], s1 = signal[j + 1];
        final frac = (t1 - t0) > 0 ? (t - t0) / (t1 - t0) : 0.0;
        result[i] = s0 + (s1 - s0) * frac;
      }
    }
    return result;
  }

  List<double> _detrend(List<double> data) {
    final mean = data.reduce((a, b) => a + b) / data.length;
    return data.map((v) => v - mean).toList();
  }

  List<double> _applyHamming(List<double> data) {
    final n = data.length;
    return List<double>.generate(
        n, (i) => data[i] * (0.54 - 0.46 * cos(2 * pi * i / (n - 1))));
  }

  /// Bandpass filter via FFT -> zero out-of-band bins -> inverse FFT.
  List<double> _bandpassFilter(
      List<double> data, double fps, double lowHz, double highHz) {
    final n = _nextPow2(data.length);
    final padded = Float64List(n);
    for (int i = 0; i < data.length; i++) {
      padded[i] = data[i];
    }
    final fft = FFT(n);
    final freqData = fft.realFft(padded);
    final binHz = fps / n;

    for (int i = 0; i < freqData.length; i++) {
      final freq = i <= n ~/ 2 ? i * binHz : (n - i) * binHz;
      if (freq < lowHz || freq > highHz) {
        freqData[i] = Float64x2.zero();
      }
    }

    final timeData = fft.realInverseFft(freqData);
    return timeData.sublist(0, data.length);
  }

  double _dominantBpm(
      List<double> data, double fps, double lowHz, double highHz) {
    final n = _nextPow2(data.length);
    final padded = Float64List(n);
    for (int i = 0; i < data.length; i++) {
      padded[i] = data[i];
    }
    final fft = FFT(n);
    final freqData = fft.realFft(padded);
    final binHz = fps / n;

    double maxMag = 0;
    int maxIdx = (lowHz / binHz).ceil().clamp(1, n ~/ 2 - 1);
    final minBin = (lowHz / binHz).ceil();
    final maxBin = (highHz / binHz).floor();

    for (int i = minBin; i <= maxBin && i < n ~/ 2; i++) {
      final re = freqData[i].x;
      final im = freqData[i].y;
      final mag = sqrt(re * re + im * im);
      if (mag > maxMag) {
        maxMag = mag;
        maxIdx = i;
      }
    }
    return (maxIdx * binHz) * 60.0;
  }

  /// HRV via RMSSD: peak-detect the filtered pulse signal, compute
  /// inter-beat intervals, then root-mean-square of successive differences.
  double _computeHRV(List<double> filteredSignal, double fps) {
    final peakIndices = <int>[];
    for (int i = 1; i < filteredSignal.length - 1; i++) {
      if (filteredSignal[i] > filteredSignal[i - 1] &&
          filteredSignal[i] > filteredSignal[i + 1] &&
          filteredSignal[i] > 0) {
        peakIndices.add(i);
      }
    }

    if (peakIndices.length < 3) return 0.0;

    final ibis = <double>[];
    for (int i = 1; i < peakIndices.length; i++) {
      final intervalSamples = peakIndices[i] - peakIndices[i - 1];
      final intervalMs = (intervalSamples / fps) * 1000;
      if (intervalMs > 300 && intervalMs < 2000) {
        ibis.add(intervalMs);
      }
    }

    if (ibis.length < 2) return 0.0;

    double sumSqDiff = 0;
    for (int i = 1; i < ibis.length; i++) {
      final diff = ibis[i] - ibis[i - 1];
      sumSqDiff += diff * diff;
    }
    return sqrt(sumSqDiff / (ibis.length - 1));
  }

  int _nextPow2(int n) {
    int p = 1;
    while (p < n) {
      p *= 2;
    }
    return p;
  }

  @override
  void onClose() {
    cameraController?.dispose();
    faceDetector.close();
    super.onClose();
  }
}
