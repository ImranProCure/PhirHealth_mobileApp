import 'package:get/get.dart';
import '../controllers/lifestyle_controller.dart';

class LifestyleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LifestyleController>(() => LifestyleController());
  }
}
