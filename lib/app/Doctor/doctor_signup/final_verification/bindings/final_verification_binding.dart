import 'package:get/get.dart';
import '../controllers/final_verification_controller.dart';

class FinalVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalVerificationController>(
      () => FinalVerificationController(),
    );
  }
}
