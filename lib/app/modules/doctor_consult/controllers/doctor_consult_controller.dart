import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class DoctorConsultController extends GetxController {
  void bookConsultation() {
    Get.toNamed(Routes.SELECT_DOCTOR);
  }

  void viewHistory() {
    // Get.toNamed(Routes.CONSULTATION_HISTORY);
  }

  void uploadReports() {
    // Get.toNamed(Routes.UPLOAD_REPORTS);
  }
}
