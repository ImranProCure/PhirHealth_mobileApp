import 'package:get/get.dart';
import '../controllers/basic_info_controller.dart';

class BasicInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BasicInfoController>(() => BasicInfoController());
  }
}
