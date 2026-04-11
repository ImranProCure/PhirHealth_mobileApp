import 'package:get/get.dart';
import '../controllers/cancer_lung_assessment_controller.dart';

class CancerLungAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerLungAssessmentController>(
        () => CancerLungAssessmentController());
  }
}
