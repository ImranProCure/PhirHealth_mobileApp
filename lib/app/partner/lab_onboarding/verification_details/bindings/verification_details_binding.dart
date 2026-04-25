import 'package:get/get.dart';
import '../controllers/verification_details_controller.dart';

class VerificationDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationDetailsController>(
      () => VerificationDetailsController(),
    );
  }
}
