import 'package:get/get.dart';
import '../controllers/cancer_assessment_controller.dart';

class CancerAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerAssessmentController>(() => CancerAssessmentController());
  }
}
