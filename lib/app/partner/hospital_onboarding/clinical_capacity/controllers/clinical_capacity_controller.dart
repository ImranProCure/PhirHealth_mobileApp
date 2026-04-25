import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ClinicalCapacityController extends GetxController {
  final totalBedsController = TextEditingController();

  final RxBool icuAvailability = true.obs;
  final RxBool emergencyServices = true.obs;
  final RxBool operationTheatres = true.obs;
  final RxBool diagnosticFacilities = true.obs;
  final RxBool pharmacyAvailability = true.obs;

  void goToNext() {
    Get.toNamed('/resource-allocation');
  }

  @override
  void onClose() {
    totalBedsController.dispose();
    super.onClose();
  }
}
