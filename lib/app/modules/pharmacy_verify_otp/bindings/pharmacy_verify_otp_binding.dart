import 'package:get/get.dart';
import '../controllers/pharmacy_verify_otp_controller.dart';

class PharmacyVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyVerifyOtpController>(
      () => PharmacyVerifyOtpController(),
    );
  }
}
