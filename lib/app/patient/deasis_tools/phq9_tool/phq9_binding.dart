import 'package:get/get.dart';
import 'phq9_controller.dart';

class Phq9Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Phq9Controller>(() => Phq9Controller());
  }
}

// ─── Routes (add to your AppPages / GetMaterialApp) ──────────────────────────
//
// GetPage(
//   name: '/phq9-info',
//   page: () => const Phq9InfoView(),
//   binding: Phq9Binding(),
// ),
// GetPage(
//   name: '/phq9-form',
//   page: () => const Phq9FormView(),
//   binding: Phq9Binding(),
// ),
// GetPage(
//   name: '/phq9-result',
//   page: () => const Phq9ResultView(),
//   binding: Phq9Binding(),
// ),
//
// Entry point: Get.toNamed('/phq9-info')
//
// ─── Imports needed in each view file ────────────────────────────────────────
//
// phq9_info_view.dart    → import 'phq9_controller.dart';
// phq9_form_view.dart    → import 'phq9_controller.dart';
// phq9_result_view.dart  → import 'phq9_controller.dart';
