import 'package:get/get.dart';

class InventoryOfferingsController extends GetxController {
  // Type of Medicines Available
  final List<String> medicineTypes = [
    'Allopathy',
    'Ayuverda',
    'Homeopathy',
    'Others',
  ];
  final RxSet<String> selectedMedicineTypes = <String>{}.obs;

  // Regulatory & Compliance toggles
  final RxBool scheduleDrugs = true.obs;
  final RxBool genericMedicines = true.obs;
  final RxBool ePrescriptions = true.obs;

  void toggleMedicineType(String type) {
    if (selectedMedicineTypes.contains(type)) {
      selectedMedicineTypes.remove(type);
    } else {
      selectedMedicineTypes.add(type);
    }
  }

  void goToNext() {
    Get.toNamed('/logistics-integration');
  }
}
