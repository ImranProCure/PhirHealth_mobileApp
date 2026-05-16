import 'package:get/get.dart';
import '../controllers/registration_edit_controller.dart';

class RegistrationEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationEditController>(
      () => RegistrationEditController(),
    );
  }
}
