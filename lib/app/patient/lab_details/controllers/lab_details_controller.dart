import 'package:get/get.dart';

class LabDetailsController extends GetxController {
  late String name;
  late String address;
  late String rating;
  late String reviews;
  late String distance;
  late String phone;

  final List<Map<String, dynamic>> services = [
    {
      'label': 'Pathology\n(Blood/Urine)',
      'imagePath': 'assets/icons/biotech.png'
    },
    {'label': 'Digital\nX-Ray', 'imagePath': 'assets/icons/radiology.png'},
    {
      'label': 'ECG/TMT\nService',
      'imagePath': 'assets/icons/blood_pressure.png'
    },
    {
      'label': 'Ultrasound /\nSonography',
      'imagePath': 'assets/icons/pregnant_woman.png'
    },
  ];

  final List<Map<String, dynamic>> tests = [
    {'name': 'CBC (Hemogram)', 'sub': 'Reports in 24 hrs', 'price': '₹350'},
    {'name': 'HbA1c (Sugar)', 'sub': 'Reports in 24 hrs', 'price': '₹450'},
    {'name': 'Thyroid Profile', 'sub': 'T3, T4, TSH', 'price': '₹600'},
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    name = args['name'] ?? 'Dr. Lal Pathlabs';
    address = 'DR LAL PATH LABS KHAJRANA SUPER CENTRE\ncall 6261152480';
    rating = args['rating'] ?? '4.5';
    reviews = args['reviews'] ?? '120 reviews';
    distance = args['distance'] ?? '0.5 km away';
    phone = args['phone'] ?? '07314010101';
  }

  void call() {}
  void book() => Get.toNamed('/book-test');
  void viewAll() {}
}
