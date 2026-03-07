import 'package:get/get.dart';

class DoctorRequestsController extends GetxController {
  final RxList<Map<String, dynamic>> requests = <Map<String, dynamic>>[
    {
      'name': 'Akansha Tripathi',
      'time': 'Tomorrow, 12 Feb, 10:00 AM',
      'type': 'Video Consultation',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
    {
      'name': 'Sanjay Parmar',
      'time': 'Tomorrow, 12 Feb, 11:00 AM',
      'type': 'Video Consultation',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
    {
      'name': 'Tanmay Bhatt',
      'time': 'Tomorrow, 12 Feb, 13:00 AM',
      'type': 'Video Consultation',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
    {
      'name': 'Aditi Rao',
      'time': 'Tomorrow, 12 Feb, 10:00 AM',
      'type': 'Video Consultation',
      'imagePath':
          'assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png',
    },
  ].obs;

  void accept(int index) {
    requests.removeAt(index);
  }

  void decline(int index) {
    requests.removeAt(index);
  }
}
