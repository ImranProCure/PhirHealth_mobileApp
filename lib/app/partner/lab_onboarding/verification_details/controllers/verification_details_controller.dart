import 'package:get/get.dart';

class VerificationDetailsController extends GetxController {
  // Each entry is unique label + index pair to handle duplicate 'T' (Tue & Thu)
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // Stores selected day INDICES (0=Mon ... 6=Sun)
  // Default: Saturday(5) and Sunday(6) selected as holidays (shown red)
  final RxSet<int> selectedDays = <int>{5, 6}.obs;

  final RxString fromTime = '08:00 AM'.obs;
  final RxString toTime = '08:00 PM'.obs;

  final RxBool emergencyService = true.obs;
  final RxBool onlineBookings = true.obs;
  final RxBool apiIntegration = false.obs;

  /// Toggle day by index — handles duplicate 'T' (Tuesday vs Thursday) correctly
  void toggleDayByIndex(int index) {
    if (selectedDays.contains(index)) {
      selectedDays.remove(index);
    } else {
      selectedDays.add(index);
    }
  }

  void submitRegistration() {
    // TODO: API call with all collected data
    // On success navigate to success screen or home
    Get.offAllNamed('/select-facility-type');
  }
}
