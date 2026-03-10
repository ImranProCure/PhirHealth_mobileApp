import 'package:get/get.dart';
import '../controllers/doctor_accept_booking_controller.dart';

class DoctorAcceptBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAcceptBookingController>(
        () => DoctorAcceptBookingController());
  }
}
