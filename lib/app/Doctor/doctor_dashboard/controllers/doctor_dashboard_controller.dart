import 'package:get/get.dart';

class DoctorDashboardController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final String doctorName = 'Dr. Sharma';
  final String date = 'Feb 12, 2026';
  final String totalEarnings = '₹ 50,500.00';

  final List<Map<String, dynamic>> stats = [
    {
      'label': 'Total Patients',
      'value': '18',
      'iconPath': 'assets/icons/group.png',
      'iconColor': 0xFF3B82F6
    },
    {
      'label': 'Completed',
      'value': '12',
      'iconPath': 'assets/icons/check_circle.png',
      'iconColor': 0xFF22C55E
    },
    {
      'label': 'Pending',
      'value': '04',
      'iconPath': 'assets/icons/pending.png',
      'iconColor': 0xFFF59E0B
    },
    {
      'label': 'Canceled',
      'value': '02',
      'iconPath': 'assets/icons/cancel.png',
      'iconColor': 0xFFEF4444
    },
  ];

  final List<Map<String, dynamic>> appointments = [
    {
      'name': 'Aditi Rao',
      'time': '10:30 AM',
      'details': 'Female | 28 years',
      'type': 'Video Consultation',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
    {
      'name': 'Kamal Verma',
      'time': '11:00 AM',
      'details': 'Male | 36 years',
      'type': 'Video Consultation',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
  ];

  // nav icon paths
  final List<Map<String, String>> navItems = [
    {'label': 'Home', 'iconPath': 'assets/home.png'},
    {'label': 'Request', 'iconPath': 'assets/stethoscope.png'},
    {'label': 'Schedule', 'iconPath': 'assets/article.png'},
    {'label': 'Profile', 'iconPath': 'assets/account_circle.png'},
  ];

  void onNavTap(int index) {
    currentIndex.value = index;
    if (index == 1) Get.toNamed('/doctor-requests');
    if (index == 2) Get.toNamed('/doctor-todays-session');
    if (index == 3) Get.toNamed('/doctor-profile');
  }

  void seeAll() {}
  void joinCall(Map<String, dynamic> apt) {}
  void onNotification() => Get.toNamed('/doctor-notifications');
}
