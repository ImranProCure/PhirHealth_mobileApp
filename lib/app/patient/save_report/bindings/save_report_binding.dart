import 'package:get/get.dart';
import '../controllers/save_report_controller.dart';

class SaveReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SaveReportController>(SaveReportController());
  }
}
