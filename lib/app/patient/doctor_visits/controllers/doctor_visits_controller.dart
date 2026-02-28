import 'package:get/get.dart';

class DoctorVisitsController extends GetxController {
  // ===== FILTER TABS =====
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = ['All', 'Completed', 'Cancelled'];

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  // ===== VISITS DATA =====
  final List<Map<String, dynamic>> allVisits = [
    {
      "month": "February 2026",
      "date_short": "FEB\n12",
      "doctor": "Dr. Jyoti Wadhwani",
      "specialty": "General Physician",
      "time": "10:30 AM",
      "type": "Video Call",
      "status": "Completed",
      "note": "",
      "show_book_again": true,
    },
    {
      "month": "January 2026",
      "date_short": "Jan\n15",
      "doctor": "Dr. Rahul Sharma",
      "specialty": "Orthopedist",
      "time": "02:30 PM",
      "type": "Clinic",
      "status": "Completed",
      "note": "\"Knee pain Checkup - Follow up Required in 2 weeks\"",
      "show_book_again": false,
    },
    {
      "month": "January 2026",
      "date_short": "Jan\n04",
      "doctor": "Dr. Sameer Verma",
      "specialty": "Dermatologist",
      "time": "11:00 AM",
      "type": "Clinic",
      "status": "Cancelled",
      "note": "",
      "show_book_again": false,
    },
  ];

  List<Map<String, dynamic>> get filteredVisits {
    if (selectedFilter.value == 'All') return allVisits;
    return allVisits.where((v) => v['status'] == selectedFilter.value).toList();
  }

  // Group visits by month
  List<String> get months {
    final seen = <String>[];
    for (final v in filteredVisits) {
      if (!seen.contains(v['month'])) seen.add(v['month']);
    }
    return seen;
  }

  List<Map<String, dynamic>> visitsForMonth(String month) {
    return filteredVisits.where((v) => v['month'] == month).toList();
  }

  void viewMoreDetails(Map<String, dynamic> visit) {
    Get.toNamed('/visit-details', arguments: {'visit': visit});
  }

  void bookAgain(Map<String, dynamic> visit) {
    Get.toNamed('/profile-details');
  }
}
