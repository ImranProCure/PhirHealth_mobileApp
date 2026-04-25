import 'package:get/get.dart';
import '../controllers/capabilities_controller.dart';

class CapabilitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CapabilitiesController>(
      () => CapabilitiesController(),
    );
  }
}
