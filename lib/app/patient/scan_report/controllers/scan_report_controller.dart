// scan_report_controller.dart
import 'package:get/get.dart';

class ScanReportController extends GetxController {
  late String time;
  late int wellnessScore;
  late String comparisonText;
  late String status;
  late List<Map<String, dynamic>> vitals;
  late String aiInsight;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    final now = DateTime.now();
    time = 'Today, ${_formatTime(now)}';
    wellnessScore = args['wellnessScore'] ?? 0;
    status = args['status'] ?? 'Unknown';
    vitals = (args['vitals'] as List<Map<String, dynamic>>?) ?? _placeholderVitals();
    aiInsight = args['aiInsight'] ?? 'No data available.';

    comparisonText = wellnessScore >= 80
        ? 'Better than 85% of users in your age group.'
        : wellnessScore >= 60
            ? 'Better than 60% of users in your age group.'
            : wellnessScore > 0
                ? 'Below average for users in your age group.'
                : 'Scan incomplete — try again for a full report.';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  List<Map<String, dynamic>> _placeholderVitals() => [
        {'value': '--', 'unit': 'bpm', 'label': 'Heart Rate', 'imagePath': 'assets/icons/favorite.png', 'iconBg': 0xFFFFF0F0},
        {'value': '--', 'unit': '', 'label': 'SpO2', 'imagePath': 'assets/icons/Group 217-1.png', 'iconBg': 0xFFEFF6FF},
        {'value': '--', 'unit': '', 'label': 'Stress Level', 'imagePath': 'assets/icons/Group 217.png', 'iconBg': 0xFFFFF8E1, 'valueLarge': true},
        {'value': '--', 'unit': '/min', 'label': 'Respiration', 'imagePath': 'assets/icons/Group 217-2.png', 'iconBg': 0xFFE0F2F1},
      ];

  void consultDoctor() => Get.toNamed('/doctor-consult');
  void done() => Get.toNamed('/dashboard');
  void download() {}
}