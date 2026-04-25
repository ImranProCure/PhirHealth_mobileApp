import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CapabilitiesController extends GetxController {
  final goalsController = TextEditingController();
  final equipmentController = TextEditingController();

  final RxBool homeSampleCollection = true.obs;
  final RxBool digitalReports = true.obs;
  final RxString selectedTimeframe = ''.obs;

  void goToNext() {
    Get.toNamed('/verification-details');
  }

  @override
  void onClose() {
    goalsController.dispose();
    equipmentController.dispose();
    super.onClose();
  }
}
