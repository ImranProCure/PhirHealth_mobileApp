import 'package:get/get.dart';
import '../controllers/cancer_stomach_assessment_controller.dart';

class CancerstomachAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerstomachAssessmentController>(
        () => CancerstomachAssessmentController());
  }
}
