import 'package:get/get.dart';

class ScanReportController extends GetxController {
  final String time = 'Today, 10:42 AM';
  final int wellnessScore = 75;
  final String comparisonText = 'Better than 85% of users in your age group.';
  final String status = 'Good Status';

  final List<Map<String, dynamic>> vitals = [
    {
      'value': '72',
      'unit': 'bpm',
      'label': 'Heart Rate',
      'imagePath': 'assets/icons/favorite.png',
      'iconBg': 0xFFFFF0F0,
    },
    {
      'value': '98%',
      'unit': '',
      'label': 'SpO2',
      'imagePath': 'assets/icons/Group 217-1.png',
      'iconBg': 0xFFEFF6FF,
    },
    {
      'value': 'Normal',
      'unit': '',
      'label': 'Stress Level',
      'imagePath': 'assets/icons/Group 217.png',
      'iconBg': 0xFFFFF8E1,
      'valueLarge': true,
    },
    {
      'value': '16',
      'unit': '/min',
      'label': 'Respiration',
      'imagePath': 'assets/icons/Group 217-2.png',
      'iconBg': 0xFFE0F2F1,
    },
  ];

  final String aiInsight =
      'Your vitals are stable. Your stress level is slightly elevated; try a 5-minute breathing exercise.';

  void consultDoctor() => Get.toNamed('/doctor-consult');
  void done() => Get.toNamed('/dashboard');
  void download() {}
}
