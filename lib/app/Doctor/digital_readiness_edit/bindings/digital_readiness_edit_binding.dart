import 'package:get/get.dart';
import '../controllers/digital_readiness_edit_controller.dart';

class DigitalReadinessEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DigitalReadinessEditController>(
      () => DigitalReadinessEditController(),
      fenix: true,
    );
  }
}
