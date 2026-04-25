import 'package:get/get.dart';

class SelectFacilityTypeController extends GetxController {
  final List<Map<String, dynamic>> facilities = [
    {
      'title': 'LAB',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/icons/biotech.png',
      'route': '/basic-info',
    },
    {
      'title': 'PHARMACY',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/icons/admin_meds.png',
      'route': '/pharmacy-registration',
    },
    {
      'title': 'HOSPITAL',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/moving_ministry.png',
      'route': '/basic-information',
    },
    {
      'title': 'CLINIC',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/icons/home_health.png',
      'route': '/clinic-registration',
    },
  ];

  void onFacilityTap(String route) => Get.toNamed(route);
}
