import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SelectDoctorController extends GetxController {
  final searchText = ''.obs;

  // List of all specialties
  final RxList<String> specialties = <String>[
    "General",
    "Skin",
    "Kids",
    "Women",
  ].obs;

// Multiple selected specialties
  final RxList<String> selectedSpecialties = <String>[].obs;

  /// Toggle selection
  void selectSpecialty(String value) {
    if (selectedSpecialties.contains(value)) {
      selectedSpecialties.remove(value);
    } else {
      selectedSpecialties.add(value);
    }
  }

  final doctors = [
    {
      "name": "Dr. Jyoti Wadhwani",
      "degree": "MBBS, MD-General",
      "fee": 500,
      "image":
          "assets/icons/freepik__female-doctor-in-white-coat-stethoscope-holding-cl__89801 1.png",
      "rating": 4.9,
      "available": true,
    },
    {
      "name": "Dr. Micheal Chen",
      "degree": "MBBS - Dermatologist",
      "fee": 700,
      "image": "assets/icons/Mask group copy.png",
      "rating": 4.9,
      "available": true,
    },
    {
      "name": "Dr. Anjali Mehta",
      "degree": "MD - Pediatrician",
      "fee": 800,
      "image": "assets/icons/Mask group.png",
      "rating": 4.9,
      "available": false,
    },
  ].obs;

  void bookDoctor(Map doctor) {
    print("Booking ${doctor["name"]}");
    Get.toNamed(Routes.PROFILE_DETAILS);
  }
}
