import 'package:get/get.dart';
import '../controllers/cancer_general_assessment_controller.dart';

class CancergeneralAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancergeneralAssessmentController>(
        () => CancergeneralAssessmentController());
  }
}
