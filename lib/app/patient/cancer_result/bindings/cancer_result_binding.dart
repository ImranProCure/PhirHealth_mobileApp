import 'package:get/get.dart';
import '../controllers/cancer_result_controller.dart';

class CancerResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerResultController>(() => CancerResultController());
  }
}
