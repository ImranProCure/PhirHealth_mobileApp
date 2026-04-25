import 'package:get/get.dart';
import '../controllers/legal_compliance_controller.dart';

class LegalComplianceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LegalComplianceController>(() => LegalComplianceController());
  }
}
