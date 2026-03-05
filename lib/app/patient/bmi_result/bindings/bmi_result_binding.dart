import 'package:get/get.dart';
import '../controllers/bmi_result_controller.dart';

class BmiResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BmiResultController>(() => BmiResultController());
  }
}
