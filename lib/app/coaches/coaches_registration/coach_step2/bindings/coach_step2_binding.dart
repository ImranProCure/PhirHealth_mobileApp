import 'package:get/get.dart';
import '../controllers/coach_step2_controller.dart';

class CoachStep2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoachStep2Controller>(() => CoachStep2Controller());
  }
}
