import 'package:get/get.dart';
import '../controllers/family_wellbeing_edit_controller.dart';

class FamilyWellbeingEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FamilyWellbeingEditController>(
      () => FamilyWellbeingEditController(),
    );
  }
}
