import 'package:get/get.dart';

class LabsNearYouController extends GetxController {
  final String location = 'Near Vijay Nagar, Indore';

  final List<Map<String, dynamic>> labs = [
    {
      'name': 'Dr. Lal PathLabs',
      'imagePath': 'assets/Mask group copy 2.png',
      'rating': '4.5',
      'reviews': '120 reviews',
      'distance': '0.5 km away',
      'tags': ['Home Collection Available', 'NABL Certified'],
      'phone': '07314010101',
    },
    {
      'name': 'Indore Diagnostics Center',
      'imagePath': 'assets/Mask group-1.png',
      'rating': '4.5',
      'reviews': '120 reviews',
      'distance': '1.5 km away',
      'tags': ['X-Ray', 'MRI', 'CT Scan Available here'],
      'phone': '07314020202',
    },
  ];

  void goToDetails(Map<String, dynamic> lab) =>
      Get.toNamed('/lab-details', arguments: lab);
  void call(String phone) {}
  void directions() {}
}
