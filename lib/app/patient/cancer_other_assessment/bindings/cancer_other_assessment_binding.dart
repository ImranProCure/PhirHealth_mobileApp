import 'package:get/get.dart';
import '../controllers/cancer_other_assessment_controller.dart';

class CancerotherAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerotherAssessmentController>(
        () => CancerotherAssessmentController());
  }
}
