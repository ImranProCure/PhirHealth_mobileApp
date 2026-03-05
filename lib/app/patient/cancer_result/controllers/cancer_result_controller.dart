import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancerResultController extends GetxController {
  late String area;
  late List<String> answers;

  // Risk level: 0.0 to 1.0
  late double riskLevel;
  late String riskLabel;
  late String riskTitle;
  late String riskDescription;

  final List<Map<String, dynamic>> findings = [
    {
      'title': 'Persistent Cough',
      'subtitle': 'Detected',
      'imagePath': 'assets/icons/Group 217 copy.png',
    },
    {
      'title': 'Hemoptsis Signs',
      'subtitle': 'Detected',
      'imagePath': 'assets/icons/Group 217-1 copy.png',
    },
    {
      'title': 'Risk History',
      'subtitle': 'Present',
      'imagePath': 'assets/icons/Group 217-2 copy.png',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    area = Get.arguments?['area'] ?? 'General Risk';
    answers = List<String>.from(Get.arguments?['answers'] ?? []);
    _calculateRisk();
  }

  void _calculateRisk() {
    // Count high risk answers
    int highRiskCount = answers
        .where((a) =>
            a.contains('Yes') || a.contains('Frequently') || a.contains('have'))
        .length;

    if (highRiskCount == 0) {
      riskLevel = 0.2;
      riskLabel = 'Low';
      riskTitle = 'Low Risk Detected';
      riskDescription =
          'Based on your symptoms, no significant risk indicators were found. Continue regular health checkups.';
    } else if (highRiskCount == 1) {
      riskLevel = 0.5;
      riskLabel = 'Moderate';
      riskTitle = 'Moderate Risk Detected';
      riskDescription =
          'Based on your symptoms, some risk indicators were found. We recommend consulting a doctor for further evaluation.';
    } else {
      riskLevel = 0.78;
      riskLabel = 'High';
      riskTitle = 'Potential Risk Detected';
      riskDescription =
          'Based on your symptoms of hemoptysis (coughing blood) and clinical history, we recommend immediate medical consultation.';
    }
  }

  void consultOncologist() => Get.toNamed('/doctor-consult');
  void downloadReport() {}
  void goToHome() => Get.offAllNamed('/dashboard');
}
