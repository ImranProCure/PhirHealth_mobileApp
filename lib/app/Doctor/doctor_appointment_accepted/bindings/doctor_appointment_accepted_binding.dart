import 'package:get/get.dart';
import '../controllers/doctor_appointment_accepted_controller.dart';

class DoctorAppointmentAcceptedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAppointmentAcceptedController>(
      () => DoctorAppointmentAcceptedController(),
    );
  }
}
