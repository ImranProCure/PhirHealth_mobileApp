import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../service/api/common_api/medicine_api/medicine_api.dart';

class MedicineReminderController extends GetxController {
  final RxInt selectedDateIndex = RxInt(-1);
  final RxBool isLoading = false.obs;

  late final List<Map<String, dynamic>> dates;

  @override
  void onInit() {
    super.onInit();
    _buildDates();
    selectedDateIndex.value = dates.indexWhere((d) => d['isToday'] == true);
    // ✅ Today ki medicines fetch karo
    fetchMedicines();
  }

  void _buildDates() {
    final now = DateTime.now();
    final daysInMonth = DateUtils.getDaysInMonth(now.year, now.month);
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    dates = List.generate(daysInMonth, (i) {
      final date = DateTime(now.year, now.month, i + 1);
      return {
        'date': (i + 1).toString().padLeft(2, '0'),
        'day': dayNames[date.weekday - 1],
        'isToday': date.day == now.day &&
            date.month == now.month &&
            date.year == now.year,
        'dateTime': date,
      };
    });
  }

  String get monthYear {
    final now = DateTime.now();
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  final RxList<Map<String, dynamic>> medicines = <Map<String, dynamic>>[].obs;

  // ✅ Date select hone pe naya data fetch karo
  void selectDate(int i) {
    selectedDateIndex.value = i;
    fetchMedicines();
  }

  // ✅ Selected date ke liye API call
  Future<void> fetchMedicines() async {
    try {
      isLoading.value = true;

      // Selected date nikalo
      final selectedDate = selectedDateIndex.value >= 0
          ? dates[selectedDateIndex.value]['dateTime'] as DateTime
          : DateTime.now();

      final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);

      final api = MedicineApi();
      final response = await api.getMyMedications(selectedDate: dateStr);

      if (response.status) {
        final data = response.data['message']['data'];
        final List medicineList = data['medicines'] ?? [];

        // ✅ API response ko UI format mein convert karo
        medicines.value = medicineList.map((med) {
          final List schedule = med['schedule'] ?? [];

          // Har medicine ke liye pehla schedule slot use karo
          final String time =
              schedule.isNotEmpty ? schedule[0]['time'] ?? '' : '';
          final String mealInstruction =
              schedule.isNotEmpty ? schedule[0]['meal_instruction'] ?? '' : '';

          return {
            'id': med['id'] ?? '',
            'time': time,
            'name': med['medication_name'] ?? '',
            'detail':
                '${med['dosage_form']} · ${med['dosage']} · $mealInstruction',
            'imagePath': 'assets/icons/medicine 1.png',
            'status': 'upcoming', // Default status
            'schedule': schedule,
          };
        }).toList();
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: const Color(0xFFFF4444),
          colorText: const Color(0xFFFFFFFF),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch: $e',
        backgroundColor: const Color(0xFFFF4444),
        colorText: const Color(0xFFFFFFFF),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void addMedicine() => Get.toNamed('/add-medicine');

  void takeMedicine(int i) {
    final updated = Map<String, dynamic>.from(medicines[i]);
    updated['status'] = 'taken';
    medicines[i] = updated;
    medicines.refresh();
  }

  void snoozeMedicine(int i) {}
}
