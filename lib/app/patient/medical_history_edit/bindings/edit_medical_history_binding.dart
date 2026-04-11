import 'package:get/get.dart';
import '../controllers/edit_medical_history_controller.dart';

class MedicalHistoryEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalHistoryEditController>(
      () => MedicalHistoryEditController(),
    );
  }
}
