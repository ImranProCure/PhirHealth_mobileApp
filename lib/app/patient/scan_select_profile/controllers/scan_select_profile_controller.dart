import 'package:get/get.dart';

class ScanSelectProfileController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  final List<Map<String, dynamic>> profiles = [
    {'name': 'Myself', 'imagePath': 'assets/icons/young-man 1.png'},
    {'name': 'Mother', 'imagePath': 'assets/icons/woman 1.png'},
    {'name': 'Sister', 'imagePath': 'assets/icons/old-man 1.png'},
  ];

  final List<Map<String, dynamic>> recentHistory = [
    {
      'name': 'My Self',
      'date': '18 March 2026',
      'time': '10:18 AM',
      'imagePath': 'assets/profile.png'
    },
    {
      'name': 'My Self',
      'date': '16 March 2026',
      'time': '12:20 PM',
      'imagePath': 'assets/profile.png'
    },
    {
      'name': 'Mother',
      'date': '13 March 2026',
      'time': '02:32 PM',
      'imagePath': 'assets/icons/Group 217 copy 2.png'
    },
    {
      'name': 'Sister',
      'date': '10 March 2026',
      'time': '03:05 PM',
      'imagePath': 'assets/icons/Group 217-1 copy 2.png'
    },
  ];

  void selectProfile(int index) => selectedIndex.value = index;

  void addProfile() {}

  void onHistoryTap(int index) {}

  void proceed() => Get.toNamed('/pre-scan-questions');
}
