import 'package:get/get.dart';
import '../controllers/cancer_risk_area_controller.dart';

class CancerRiskAreaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerRiskAreaController>(() => CancerRiskAreaController());
  }
}
