import 'package:get/get.dart';
import 'package:sample/app/patient/pre_scan_questions/controllers/pre_scan_questions_controller.dart';

class PreScanQuestionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreScanQuestionsController>(() => PreScanQuestionsController());
  }
}
