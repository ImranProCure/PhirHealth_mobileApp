import 'package:get/get.dart';
import '../controllers/pharmacy_registration_controller.dart';

class PharmacyRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyRegistrationController>(
        () => PharmacyRegistrationController());
  }
}
