import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MedicineReminderController extends GetxController {
  // Selected date index (0=Mon, 1=Tue, etc.)
  final RxInt selectedDateIndex = 3.obs;

  final List<Map<String, dynamic>> dates = [
    {'day': 'Mon', 'date': '09'},
    {'day': 'Tue', 'date': '10'},
    {'day': 'Wed', 'date': '11'},
    {'day': 'Thu', 'date': '12'},
    {'day': 'Fri', 'date': '13'},
  ];

  final RxList<Map<String, dynamic>> medicines = <Map<String, dynamic>>[
    {
      'time': '08:00 AM',
      'name': 'Thyronorm',
      'detail': '(25mcg) 1 Tablet . Empty Stomach',
      'imagePath': 'assets/icons/medicine 1.png',
      'status': 'taken',
    },
    {
      'time': '01:00 PM',
      'name': 'Vitamin D3',
      'detail': '1 Capsule . After Lunch',
      'imagePath': 'assets/icons/medicine 1.png',
      'status': 'pending',
    },
    {
      'time': '09:00 PM',
      'name': 'Metformin',
      'detail': '1 Tablet . After Dinner',
      'imagePath': 'assets/icons/medicine 1.png',
      'status': 'upcoming',
    },
  ].obs;

  void selectDate(int i) => selectedDateIndex.value = i;
  void addMedicine() => Get.toNamed('/add-medicine');
  void takeMedicine(int i) {
    final updated = Map<String, dynamic>.from(medicines[i]);
    updated['status'] = 'taken';
    medicines[i] = updated;
    medicines.refresh();
  }

  void snoozeMedicine(int i) {}
}
