import 'package:get/get.dart';
import '../controllers/coach_step6_controller.dart';

class CoachStep6Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoachStep6Controller>(() => CoachStep6Controller());
  }
}
