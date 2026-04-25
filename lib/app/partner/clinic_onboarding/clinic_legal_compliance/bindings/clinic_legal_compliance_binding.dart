import 'package:get/get.dart';
import '../controllers/clinic_legal_compliance_controller.dart';

class ClinicLegalComplianceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ClinicLegalComplianceController>(
        () => ClinicLegalComplianceController());
  }
}
