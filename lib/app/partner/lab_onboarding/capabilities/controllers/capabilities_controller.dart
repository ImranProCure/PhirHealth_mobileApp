import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';

class CapabilitiesController extends GetxController {
  final goalsController = TextEditingController();
  final equipmentController = TextEditingController();

  final RxBool homeSampleCollection = true.obs;
  final RxBool digitalReports = true.obs;
  final RxString selectedTimeframe = ''.obs;

  void goToNext() {
    if (goalsController.text.trim().isEmpty) {
      showError('Please enter goals & objective');
      return;
    }
    if (selectedTimeframe.value.isEmpty) {
      showError('Please select average report delivery time');
      return;
    }
    if (equipmentController.text.trim().isEmpty) {
      showError('Please enter equipment details');
      return;
    }
    Get.toNamed('/verification-details');
  }

  @override
  void onClose() {
    goalsController.dispose();
    equipmentController.dispose();
    super.onClose();
  }
}
