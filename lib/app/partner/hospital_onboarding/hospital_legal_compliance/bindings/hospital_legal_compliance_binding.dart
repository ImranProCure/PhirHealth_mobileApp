import 'package:get/get.dart';
import '../controllers/hospital_legal_compliance_controller.dart';

class HospitalLegalComplianceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalLegalComplianceController>(
        () => HospitalLegalComplianceController());
  }
}
