import 'package:get/get.dart';
import '../controllers/experience_edit_controller.dart';

class ExperienceEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExperienceEditController>(
      () => ExperienceEditController(),
    );
  }
}
