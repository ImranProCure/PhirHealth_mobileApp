import 'package:get/get.dart';
import '../controllers/coach_step1_controller.dart';

class CoachStep1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoachStep1Controller>(() => CoachStep1Controller());
  }
}
