import 'package:get/get.dart';
import 'mdrd_gfr_controller.dart';

class MdrdGfrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MdrdGfrController>(() => MdrdGfrController());
  }
}

// ─── Routes (add to your AppPages / GetMaterialApp) ──────────────────────────
//
// GetPage(
//   name: '/mdrd-info',
//   page: () => const MdrdGfrInfoView(),
//   binding: MdrdGfrBinding(),
// ),
// GetPage(
//   name: '/mdrd-form',
//   page: () => const MdrdGfrFormView(),
//   binding: MdrdGfrBinding(),
// ),
// GetPage(
//   name: '/mdrd-result',
//   page: () => const MdrdGfrResultView(),
//   binding: MdrdGfrBinding(),
// ),
//
// Entry point: Get.toNamed('/mdrd-info')
//
// ─── Imports needed in each view file ────────────────────────────────────────
//
// mdrd_gfr_info_view.dart    → import 'mdrd_gfr_controller.dart';
// mdrd_gfr_form_view.dart    → import 'mdrd_gfr_controller.dart';
// mdrd_gfr_result_view.dart  → import 'mdrd_gfr_controller.dart';
//                              import 'dart:math';
