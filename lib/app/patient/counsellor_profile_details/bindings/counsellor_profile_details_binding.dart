import 'package:get/get.dart';
import '../controllers/counsellor_profile_details_controller.dart';

class CounsellorProfileDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounsellorProfileDetailsController>(
      () => CounsellorProfileDetailsController(),
    );
  }
}
