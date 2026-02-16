import 'package:get/get.dart';
import '../controllers/identity_vitals_controller.dart';

class IdentityVitalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdentityVitalsController>(
      () => IdentityVitalsController(),
    );
  }
}
