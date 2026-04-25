import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogisticsIntegrationController extends GetxController {
  // Home Delivery toggle
  final RxBool homeDelivery = true.obs;

  // Delivery time selection: '2hours' | 'sameday' | 'custom'
  final RxString selectedDeliveryTime = '2hours'.obs;

  // Custom time text field
  final customTimeController = TextEditingController();

  // Online Order Management System
  final RxBool omsAvailable = true.obs;

  void selectDeliveryTime(String value) {
    selectedDeliveryTime.value = value;
    if (value != 'custom') {
      customTimeController.clear();
    }
  }

  void goToNext() {
    Get.toNamed('/legal-compliance');
  }

  @override
  void onClose() {
    customTimeController.dispose();
    super.onClose();
  }
}
