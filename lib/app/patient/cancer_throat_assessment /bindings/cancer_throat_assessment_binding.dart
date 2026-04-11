import 'package:get/get.dart';
import '../controllers/cancer_throat_assessment_controller.dart';

class CancerthroatAssessmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerthroatAssessmentController>(
        () => CancerthroatAssessmentController());
  }
}
