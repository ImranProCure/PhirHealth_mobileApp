import 'package:get/get.dart';
import '../controllers/coach_step3_controller.dart';

class CoachStep3Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoachStep3Controller>(() => CoachStep3Controller());
  }
}
