import 'package:get/get.dart';
import '../controllers/cancer_skin_assessment_controller.dart';

class CancerskinAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerskinAssessmentController>(
        () => CancerskinAssessmentController());
  }
}
