import 'package:get/get.dart';
import '../controllers/counsellor_coaches_controller.dart';

class CounsellorCoachesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounsellorCoachesController>(
      () => CounsellorCoachesController(),
    );
  }
}
