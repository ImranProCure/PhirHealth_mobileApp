import 'package:get/get.dart';

class DoctorNotificationController extends GetxController {
  final emergency = {
    'title': 'Emergency Reschedule Request',
    'body':
        "Amit Singh has requested to reschedule today's appointment due to an emergency.",
    'time': '2m ago',
  };

  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New lab reports uploaded by priya',
      'body': 'Hematology and CBC reports are now available fir review.',
      'time': '2m ago',
      'iconBg': 0xFFEEF2FF,
      'iconColor': 0xFF6366F1,
      'iconPath': 'assets/icons/lab_report.png',
    },
    {
      'title': 'Consultation Fee Received',
      'body': 'Payment for Dr. Sharma consultation has been processed.',
      'time': '2m ago',
      'iconBg': 0xFFE0F2F1,
      'iconColor': 0xFF0D9488,
      'iconPath': 'assets/icons/rupee.png',
    },
    {
      'title': 'System Maintenance',
      'body': 'App will be under maintenance from 2 AM to 4 AM tonight.',
      'time': '2m ago',
      'iconBg': 0xFFFFF7ED,
      'iconColor': 0xFFF59E0B,
      'iconPath': 'assets/icons/system_maintenance.png',
    },
  ];

  void accept() => Get.back();
  void decline() => Get.back();
}
