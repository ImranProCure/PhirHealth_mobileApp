import 'package:get/get.dart';
import '../../../../app/controllers/role_controller.dart';
import 'package:flutter/material.dart';
import 'package:sample/app/modules/login/views/login_view.dart';
import 'package:sample/app/modules/login/bindings/login_binding.dart';

class SelectFacilityTypeController extends GetxController {
  final RoleController _roleController = Get.find<RoleController>();

  final List<Map<String, dynamic>> facilities = [
    {
      'title': 'LAB',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/icons/biotech.png',
      'partnerType': PartnerType.lab, // 👈 route hata, partnerType add kiya
    },
    {
      'title': 'PHARMACY',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/icons/admin_meds.png',
      'partnerType': PartnerType.pharmacy,
    },
    {
      'title': 'HOSPITAL',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/moving_ministry.png',
      'partnerType': PartnerType.hospital,
    },
    {
      'title': 'CLINIC',
      'subtitle': 'Onboarding',
      'iconPath': 'assets/icons/home_health.png',
      'partnerType': PartnerType.clinic,
    },
  ];

  void onFacilityTap(PartnerType type) {
    // 👈 String route → PartnerType type
    _roleController.selectRole(UserRole.partner);
    _roleController.selectPartnerType(type); // 👈 yahi missing tha!

    debugPrint('Role => ${_roleController.role}');
    debugPrint('PartnerType => ${_roleController.partnerType}');

    Get.off(
      () => const LoginView(),
      binding: LoginBinding(),
    );
  }
}
