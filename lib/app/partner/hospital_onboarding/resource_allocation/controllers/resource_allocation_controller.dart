import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResourceAllocationController extends GetxController {
  final doctorCountController = TextEditingController();

  final RxBool visitingConsultants = true.obs;
  final RxBool hmsInstalled = true.obs;
  final RxBool teleConsultation = true.obs;

  void goToNext() {
    Get.toNamed('/hospital-legal-compliance');
  }

  @override
  void onClose() {
    doctorCountController.dispose();
    super.onClose();
  }
}
