import 'package:get/get.dart';
import '../controllers/family_wellbeing_controller.dart';

class FamilyWellbeingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyWellbeingController>(
      () => FamilyWellbeingController(),
    );
  }
}
