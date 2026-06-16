// scan_report_controller.dart
import 'package:get/get.dart';
import 'package:sample/app/service/db/db.dart';
import 'scan_report_pdf_service.dart';

class ScanReportController extends GetxController {
  // Inject authStorage the same way the rest of the app does
  AuthStorageService authStorage = AuthStorageService();

  late String time;
  late int wellnessScore;
  late String comparisonText;
  late String status;
  late List<Map<String, dynamic>> vitals;
  late String aiInsight;

  // Raw vital values kept for PDF generation
  int? _heartRate;
  int? _respiration;
  int? _stress;
  bool _scanSuccess = false;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    final now = DateTime.now();
    time = 'Today, ${_formatTime(now)}';

    _scanSuccess = args['success'] == true;
    wellnessScore = (args['wellness_score'] as num?)?.toInt() ?? 0;

    _heartRate = (args['heart_rate'] as num?)?.toInt();
    _respiration = (args['respiration'] as num?)?.toInt();
    _stress = (args['stress'] as num?)?.toInt();

    status = _scanSuccess ? 'Scan Complete' : 'Scan Failed';

    vitals = _scanSuccess
        ? [
            {
              'value': _heartRate?.toString() ?? '--',
              'unit': 'bpm',
              'label': 'Heart Rate',
              'imagePath': 'assets/icons/favorite.png',
              'iconBg': 0xFFFFF0F0
            },
            {
              'value': _respiration?.toString() ?? '--',
              'unit': 'breaths/min',
              'label': 'Respiration',
              'imagePath': 'assets/icons/Group 217-2.png',
              'iconBg': 0xFFE0F2F1
            },
            {
              'value': _stress?.toString() ?? '--',
              'unit': '',
              'label': 'Stress Level',
              'imagePath': 'assets/icons/Group 217.png',
              'iconBg': 0xFFFFF8E1,
              'valueLarge': true
            },
            {
              'value': wellnessScore.toString(),
              'unit': '',
              'label': 'Wellness Score',
              'imagePath': 'assets/icons/Group 217-1.png',
              'iconBg': 0xFFEFF6FF,
              'valueLarge': true
            },
          ]
        : _placeholderVitals();

    aiInsight = _scanSuccess
        ? _generateInsight(_heartRate, _respiration, _stress, wellnessScore)
        : 'Could not reach the analysis server or scan was too short. Please try again with better lighting.';

    comparisonText = wellnessScore >= 80
        ? 'Better than 85% of users in your age group.'
        : wellnessScore >= 60
            ? 'Better than 60% of users in your age group.'
            : wellnessScore > 0
                ? 'Below average for users in your age group.'
                : 'Scan incomplete — try again for a full report.';
  }

  String _generateInsight(int? hr, int? resp, int? stress, int score) {
    final parts = <String>[];

    if (hr != null) {
      if (hr < 60) {
        parts.add(
            'Your heart rate is on the lower side, which is common in resting or well-conditioned individuals.');
      } else if (hr <= 100) {
        parts.add('Your heart rate is within a normal resting range.');
      } else {
        parts.add(
            'Your heart rate is elevated — consider resting and rechecking later.');
      }
    }

    if (stress != null) {
      if (stress <= 30) {
        parts.add('Stress levels appear low.');
      } else if (stress <= 60) {
        parts.add('Stress levels are moderate.');
      } else {
        parts.add(
            'Stress levels appear high — relaxation techniques may help.');
      }
    }

    if (resp != null) {
      if (resp < 12) {
        parts.add('Respiration rate is slightly low.');
      } else if (resp <= 20) {
        parts.add('Respiration rate is within the normal range.');
      } else {
        parts.add('Respiration rate is slightly elevated.');
      }
    }

    if (score >= 80) {
      parts.add('Overall, your wellness indicators look great.');
    } else if (score >= 60) {
      parts.add('Overall, your wellness indicators look fairly good.');
    } else {
      parts.add('Overall, there may be room to improve your wellness habits.');
    }

    return parts.join(' ');
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  List<Map<String, dynamic>> _placeholderVitals() => [
        {
          'value': '--',
          'unit': 'bpm',
          'label': 'Heart Rate',
          'imagePath': 'assets/icons/favorite.png',
          'iconBg': 0xFFFFF0F0
        },
        {
          'value': '--',
          'unit': '',
          'label': 'SpO2',
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
      ];

  void consultDoctor() => Get.toNamed('/doctor-consult');
  void done() => Get.toNamed('/dashboard');

  /// Fetches the user name then generates and shares the PDF report.
  Future<void> download() async {
    // Fetch user details — same call your FutureBuilder already uses
    final userDetail = await authStorage.getUserDetail();
    final userName = (userDetail?['full_name'] as String? ?? '').trim();

    await ScanReportPdfService.downloadReport(
      time: time,
      status: status,
      heartRate: _heartRate,
      respiration: _respiration,
      stress: _stress,
      wellnessScore: wellnessScore,
      aiInsight: aiInsight,
      comparisonText: comparisonText,
      scanSuccess: _scanSuccess,
      userName: userName.isNotEmpty ? userName : 'User',
    );
  }
}