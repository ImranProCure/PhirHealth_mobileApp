import 'package:get/get.dart';
import '../controllers/doctor_earnings_controller.dart';

class DoctorEarningsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorEarningsController>(() => DoctorEarningsController());
  }
}
