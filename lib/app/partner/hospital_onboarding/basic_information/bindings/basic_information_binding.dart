import 'package:get/get.dart';
import '../controllers/basic_information_controller.dart';

class BasicInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BasicInformationController>(() => BasicInformationController());
  }
}
