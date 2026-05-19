// ─── Binding ──────────────────────────────────────────────────────────────────
// ascvd_binding.dart

import 'package:get/get.dart';
import 'package:sample/app/patient/deasis_tools/qrisk3_tool/qrisk3_controller.dart';

class Qrisk3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Qrisk3Controller>(() => Qrisk3Controller());
  }
}


// ─── Routes (add to your AppPages / GetMaterialApp) ──────────────────────────
//
// GetPage(
//   name: '/ascvd-info',
//   page: () => const AscvdInfoView(),
//   binding: AscvdBinding(),
// ),
// GetPage(
//   name: '/ascvd-form',
//   page: () => const AscvdFormView(),
//   binding: AscvdBinding(),
// ),
// GetPage(
//   name: '/ascvd-result',
//   page: () => const AscvdResultView(),
//   binding: AscvdBinding(),
// ),
//
// Entry point: Get.toNamed('/ascvd-info')
//
// ─── Imports needed in each view file ────────────────────────────────────────
//
// ascvd_info_view.dart    → import '../controllers/ascvd_controller.dart';
// ascvd_form_view.dart    → import '../controllers/ascvd_controller.dart';
// ascvd_result_view.dart  → import '../controllers/ascvd_controller.dart';
//                           import 'dart:math';
