import 'package:get/get.dart';
import '../controllers/lifestyle_edit_controller.dart';

class LifestyleEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LifestyleEditController>(() => LifestyleEditController());
  }
}
