import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';

void showError(String message) {
  Get.snackbar(
    "Validation Error",
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red,
    colorText: Colors.white,
  );
}

void showMessage(String message) {
  Get.snackbar(
    "Success",
    message,
    duration: Duration(seconds: 1),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green.shade100,
    colorText: Colors.green.shade900,
  );
}
