import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FindHospitalController extends GetxController {
  final RxString selectedFilter = 'All'.obs;
  final String location = 'Near Vijay Nagar, Indore';

  final List<String> filters = ['All', 'Emergency', 'Pharmacy'];

  final List<Map<String, dynamic>> hospitals = [
    {
      'name': 'Bombay Hospital',
      'imagePath': 'assets/bombay_hospital.png',
      'status': 'Open 24x7',
      'distance': '0.8 km away',
      'tags': ['Multi-speciality', 'ICU', 'Ambulance'],
      'phone': '07314010101',
    },
    {
      'name': 'Apollo Clinic',
      'imagePath': 'assets/apollo_clinic.png',
      'status': 'Open 24x7',
      'distance': '1.5 km away',
      'tags': ['Diagnostic', 'Pharmacy'],
      'phone': '07314020202',
    },
  ];

  void selectFilter(String f) => selectedFilter.value = f;

  void goToDetails(Map<String, dynamic> hospital) =>
      Get.toNamed('/hospital-details', arguments: hospital);

  void call(String phone) {}
  void directions() {}
}
