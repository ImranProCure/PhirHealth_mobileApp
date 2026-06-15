import 'package:get/get.dart';
import '../controllers/clinic_verify_opt_controller.dart';

class ClinicVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicVerifyOtpController>(
      () => ClinicVerifyOtpController(),
    );
  }
}
