import 'package:get/get.dart';
import '../controllers/clinic_registration_controller.dart';

class ClinicRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicRegistrationController>(
        () => ClinicRegistrationController());
  }
}
