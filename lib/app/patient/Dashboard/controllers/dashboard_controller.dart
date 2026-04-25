import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt selectedNavIndex = 0.obs;

  void selectNav(int index) {
    selectedNavIndex.value = index;
    if (index == 1) Get.toNamed('/doctor-consult');
    if (index == 3) Get.toNamed('/shorts-reels');
    if (index == 4) Get.toNamed('/my-profile');
  }

  // ===== DOCTOR ACTIONS =====
  final List<Map<String, String>> doctorActions = [
    {'icon': 'assets/icons/stethoscope1.png', 'label': 'Doctor\nConsult'},
    {
      'icon': 'assets/icons/ar_on_you.png',
      'label': 'Face Scan /\nHealth Vitals'
    },
    {'icon': 'assets/icons/health_cross.png', 'label': 'Network\nLocator'},
    {
      'icon': 'assets/icons/health_and_safety.png',
      'label': 'Counsellor\nand Coaches'
    },
    {
      'icon': 'assets/icons/lab_research.png',
      'label': 'Lab Tests\n(Diagnostics)'
    },
    {
      'icon': 'assets/icons/supervisor_account.png',
      'label': 'Insurance &\nProtection'
    },
  ];

  void onDoctorActionTap(int index) {
    if (index == 0) Get.toNamed('/doctor-consult');
    if (index == 1) Get.toNamed('/scan-select-profile');
    if (index == 2) Get.toNamed('/find-hospital');
    if (index == 3) Get.toNamed('/counsellor-consult');
    if (index == 4) Get.toNamed('/lab-tests');
  }

  // ===== SMART HEALTH TOOLS =====
  final List<Map<String, dynamic>> smartTools = [
    {
      'title': 'Check\nYour BMI',
      'icon': 'assets/icons/bmi 1.png',
      'route': '/bmi'
    },
    {
      'title': 'Diet &\nNutrition',
      'icon': 'assets/icons/salad 1.png',
      'route': '/ai-nutritionist'
    },
    {
      'title': 'Medicine\nReminder',
      'icon': 'assets/icons/time 1.png',
      'route': '/add-medicine'
    },
  ];

  void onSmartToolTap(int index) {
    final route = smartTools[index]['route'] as String;
    Get.toNamed(route);
  }

  // ===== AI + MEDICINE + FITNESS =====
  void goToSavingsOffers() => Get.toNamed('/savings-offers');
  void goToFitnessTracker() => Get.toNamed('/fitness-tracker');
  void goToCancerAiScan() => Get.toNamed('/cancer-ai-scan');
}
