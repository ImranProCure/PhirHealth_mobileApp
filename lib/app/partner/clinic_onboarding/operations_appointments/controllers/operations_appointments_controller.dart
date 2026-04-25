import 'package:get/get.dart';

class OperationsAppointmentsController extends GetxController {
  // Days — index based (0=M, 1=T, 2=W, 3=T, 4=F, 5=S, 6=S)
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // Default Saturday(5) + Sunday(6) as holidays (red)
  final RxSet<int> selectedDays = <int>{5, 6}.obs;

  final RxString fromTime = '08:00 AM'.obs;
  final RxString toTime = '08:00 PM'.obs;

  final RxBool appointmentBooking = true.obs;
  final RxBool teleConsultation = true.obs;

  void toggleDayByIndex(int index) {
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
  }

  void goToNext() {
    Get.toNamed('/clinic-legal-compliance');
  }
}
