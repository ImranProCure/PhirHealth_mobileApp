import 'package:get/get.dart';
import '../controllers/doctor_verify_otp_controller.dart';

class DoctorVerifyOtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorVerifyOtpController>(() => DoctorVerifyOtpController());
  }
}
