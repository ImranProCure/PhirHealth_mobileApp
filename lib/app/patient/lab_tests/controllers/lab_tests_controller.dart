import 'package:get/get.dart';

class LabTestsController extends GetxController {
  final commonTests = [
    {'label': 'Blood /\nCBC', 'imagePath': 'assets/icons/bloodtype.png'},
    {'label': 'Sugar /\nDiabetes', 'imagePath': 'assets/icons/glucose.png'},
    {'label': 'Thyroid', 'imagePath': 'assets/icons/biotech.png'},
    {'label': 'Dengue /\nFever', 'imagePath': 'assets/icons/dew_point.png'},
    {'label': 'Heart\nProfile', 'imagePath': 'assets/icons/monitor_heart.png'},
    {'label': 'Urine Test', 'imagePath': 'assets/icons/labs.png'},
  ];

  final recommended = [
    {
      'title': 'Individual Checkup',
      'sub': 'Baseline health tracking for adults aged 18-40.',
      'price': '₹1,499',
    },
    {
      'title': 'Individual Checkup',
      'sub': 'Baseline health tracking for adults aged 18-40.',
      'price': '₹1,499',
    },
  ];

  void bookNow() => Get.toNamed('/labs-near-you');
}
