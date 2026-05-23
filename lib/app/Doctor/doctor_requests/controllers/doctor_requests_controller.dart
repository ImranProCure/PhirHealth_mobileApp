import 'package:get/get.dart';
import 'package:sample/app/common_function.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../../../service/api/common_api/doctor_pending_request_api/doctor_pending_request_api.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';

class DoctorRequestsController extends GetxController {
  final DoctorPendingRequestApi _requestsApi = DoctorPendingRequestApi();

  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> requests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPendingRequests();
  }

  /// ================= FORMAT DATE =================
  String _formatDate(String dateStr, String timeStr) {
    try {
      final appointmentDate = DateTime.parse(dateStr);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final aptDay = DateTime(
          appointmentDate.year, appointmentDate.month, appointmentDate.day);

      if (aptDay == today) {
        return 'Today, $timeStr';
      } else if (aptDay == today.add(const Duration(days: 1))) {
        return 'Tomorrow, $timeStr';
      } else {
        // "14 May, 9:00 AM"
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return '${appointmentDate.day} ${months[appointmentDate.month - 1]}, $timeStr';
      }
    } catch (_) {
      return '$dateStr, $timeStr';
    }
  }

  /// ================= FETCH PENDING REQUESTS =================
  Future<void> fetchPendingRequests() async {
    try {
      isLoading.value = true;

      final ApiResponse response = await _requestsApi.getPendingRequests();
      final message = response.data['message'];

      if (message != null &&
          (message['status'] == true ||
              message['status'].toString() == 'True')) {
        final data = message['data'] as Map<String, dynamic>? ?? {};
        final apts = data['appointments'] as List? ?? [];

        final today = DateTime.now();
        final todayOnly = DateTime(today.year, today.month, today.day);

        final filtered = apts.where((apt) {
          try {
            final d = DateTime.parse(apt['date']?.toString() ?? '');
            return !DateTime(d.year, d.month, d.day).isBefore(todayOnly);
          } catch (_) {
            return true;
          }
        }).toList();

        requests.assignAll(
          filtered.map((apt) {
            final image = apt['patient_image']?.toString() ?? '';
            return {
              'appointment_id': apt['appointment_id']?.toString() ?? '',
              'name': apt['patient_name']?.toString() ?? '',
              'time': _formatDate(
                apt['date']?.toString() ?? '',
                apt['time']?.toString() ?? '',
              ),
              'raw_date': apt['date']?.toString() ?? '',
              'type': apt['appointment_mode']?.toString() ?? '',
              'status': apt['status']?.toString() ?? '',
              'imagePath': image.isNotEmpty
                  ? ApiConstants.imageUrl(image) // ✅
                  : 'assets/icons/account_circle.png',
            };
          }).toList(),
        );
      } else {
        showError(message?['message']?.toString() ?? 'Failed to load requests');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= ACCEPT =================
  void accept(int index) async {
    final request = requests[index];
    final appointmentId = request['appointment_id'] as String;

    try {
      isLoading.value = true;
      final ApiResponse response =
          await _requestsApi.acceptAppointment(appointmentId);
      final message = response.data['message'];

      if (message != null &&
          (message['status'] == true ||
              message['status'].toString() == 'True')) {
        requests.removeAt(index);
        // API response ka data next screen pe bhejo
        Get.toNamed('/doctor-appointment-accepted', arguments: message['data']);
      } else {
        showError(message?['message']?.toString() ?? 'Failed to accept');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= DECLINE =================
  void decline(int index) async {
    final request = requests[index];
    final appointmentId = request['appointment_id'] as String;

    try {
      isLoading.value = true;
      final ApiResponse response =
          await _requestsApi.cancelAppointment(appointmentId);
      final message = response.data['message'];

      if (message != null &&
          (message['status'] == true ||
              message['status'].toString() == 'True')) {
        requests.removeAt(index);
        Get.snackbar('Success',
            message['message']?.toString() ?? 'Appointment cancelled',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        showError(message?['message']?.toString() ?? 'Failed to cancel');
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void onCardTap(int index) {
    Get.toNamed('/doctor-accept-booking', arguments: requests[index]);
  }
}
