import 'package:get/get.dart';
import '../controllers/digital_readiness_controller.dart';

class DigitalReadinessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DigitalReadinessController>(
      () => DigitalReadinessController(),
    );
  }
}
