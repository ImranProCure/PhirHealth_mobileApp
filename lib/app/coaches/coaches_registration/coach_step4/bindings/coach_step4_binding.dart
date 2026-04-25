import 'package:get/get.dart';
import '../controllers/coach_step4_controller.dart';

class CoachStep4Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CoachStep4Controller>(() => CoachStep4Controller());
  }
}
