import 'package:get/get.dart';
import '../controllers/scan_report_controller.dart';

class ScanReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScanReportController>(() => ScanReportController());
  }
}
