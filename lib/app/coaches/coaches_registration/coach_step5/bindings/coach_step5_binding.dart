import 'package:get/get.dart';
import '../controllers/coach_step5_controller.dart';

class CoachStep5Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoachStep5Controller>(() => CoachStep5Controller());
  }
}
