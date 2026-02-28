import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CancerRiskController extends GetxController {
  void startDetection() => Get.toNamed('/cancer-risk-area');
  void consultDoctor() => Get.toNamed('/doctor-consult');
}
