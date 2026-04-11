import 'package:get/get.dart';
import '../controllers/identity_vitals_edit_controller.dart';

class IdentityVitalsEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IdentityVitalsEditController>(
      () => IdentityVitalsEditController(),
    );
  }
}
