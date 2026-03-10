import 'package:get/get.dart';

class DoctorTodaysSessionController extends GetxController {
  final String todayDate = 'Tuesday, February 12, 2026';

  final List<Map<String, dynamic>> sessions = [
    {
      'name': 'Komal Verma',
      'gender': 'Female',
      'age': '25 years',
      'type': 'Video Consultation',
      'time': '10:30 AM',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
    {
      'name': 'Vihan Arya',
      'gender': 'Male',
      'age': '24 years',
      'type': 'Video Consultation',
      'time': '11:00 AM',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
    {
      'name': 'Aakash',
      'gender': 'Male',
      'age': '36 years',
      'type': 'Video Consultation',
      'time': '12:00 PM',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
  ];

  void joinCall(int index) {
    Get.toNamed('/doctor-patient-detail', arguments: sessions[index]);
  }
}
