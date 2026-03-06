import 'package:get/get.dart';

class HospitalDetailsController extends GetxController {
  late String name;
  late String imagePath;
  late String address;
  late String status;
  late String distance;
  late String phone;

  final List<Map<String, dynamic>> services = [
    {'label': 'Ambulance', 'imagePath': 'assets/icons/ambulance.png'},
    {'label': 'X-Ray', 'imagePath': 'assets/icons/radiology.png'},
    {'label': 'Blood Bank', 'imagePath': 'assets/icons/bloodtype.png'},
    {'label': 'Pharmacy', 'imagePath': 'assets/icons/admin_meds.png'},
  ];

  final List<Map<String, dynamic>> departments = [
    {
      'name': 'General Physician',
      'sub': 'Fever, Flu, BP, Sugar',
      'available': '3 Doctors Available',
      'isAvailable': true,
      'imagePath': 'assets/icons/stethoscope.png',
    },
    {
      'name': 'Orthopedist',
      'sub': 'Joint Pain, Fracture, Bone',
      'available': '1 Doctor Available',
      'isAvailable': true,
      'imagePath': 'assets/icons/femur.png',
    },
    {
      'name': 'Cardiologist',
      'sub': 'Chest Pain, Heart Checkup',
      'available': 'Unavailable Now (Next: 5 PM)',
      'isAvailable': false,
      'imagePath': 'assets/icons/ecg_heart.png',
    },
    {
      'name': 'Neurologist',
      'sub': 'Migraine, Nerve Issues',
      'available': '2 Available',
      'isAvailable': true,
      'imagePath': 'assets/icons/neurology.png',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    name = args['name'] ?? 'Bombay Hospital';
    imagePath = args['imagePath'] ?? 'assets/bombay_hospital.png';
    address =
        'Ring Road, Near IDA Scheme no. 94, Vijay Nagar, Indore, MP 452010';
    status = args['status'] ?? 'Open 24x7';
    distance = args['distance'] ?? '0.8 km';
    phone = args['phone'] ?? '07314010101';
  }

  void call() {}
  void directions() {}
}
