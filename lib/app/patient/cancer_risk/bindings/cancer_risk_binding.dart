import 'package:get/get.dart';
import '../controllers/cancer_risk_controller.dart';

class CancerRiskBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CancerRiskController>(() => CancerRiskController());
  }
}
