// face_scan_binding.dart
import 'package:get/get.dart';
import 'package:sample/app/patient/scan_report/controllers/face_scan_controller.dart';

class FaceScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaceScanController>(() => FaceScanController());
  }
}