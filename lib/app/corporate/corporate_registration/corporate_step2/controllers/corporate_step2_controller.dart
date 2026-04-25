import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CorporateStep2Controller extends GetxController {
  // Interest Areas
  final List<String> interestAreas = [
    'PHIR Shikha',
    'PHIR School',
    'PHIR Health',
    'PHIR Wealth',
    'PHIR Marry',
  ];
  final RxSet<String> selectedInterests = <String>{}.obs;

  // Service Required
  final List<String> services = [
    'Training',
    'Hiring',
    'Healthcare',
    'Financial Advisory',
  ];
  final RxSet<String> selectedServices = <String>{}.obs;

  // Text fields
  final goalsController = TextEditingController();
  final challengesController = TextEditingController();
  final audienceController = TextEditingController();

  void toggleInterest(String area) {
    if (selectedInterests.contains(area)) {
      selectedInterests.remove(area);
    } else {
      selectedInterests.add(area);
    }
  }

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
  }

  void goToNext() {
    Get.toNamed('/corporate-step3');
  }

  @override
  void onClose() {
    goalsController.dispose();
    challengesController.dispose();
    audienceController.dispose();
    super.onClose();
  }
}
