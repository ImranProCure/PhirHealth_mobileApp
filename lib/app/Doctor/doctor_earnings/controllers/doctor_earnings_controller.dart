import 'package:get/get.dart';

class DoctorEarningsController extends GetxController {
  final String totalEarnings = '₹ 50,500.00';
  final String weekEarnings = '₹XX,XXX';
  final String monthEarnings = '₹XX,XXX';
  final String weekGrowth = '+12% from last week';
  final String monthGrowth = '+12% from last week';

  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = ['All', 'Completed', 'Pending'];

  final List<Map<String, String>> transactions = [
    {'name': 'Aman Arora', 'date': '22 Jan 2026', 'amount': '₹XXX'},
    {'name': 'Akshita mahajan', 'date': '21 Jan 2026', 'amount': '₹XXX'},
    {'name': 'Akshita mahajan', 'date': '21 Jan 2026', 'amount': '₹XXX'},
    {'name': 'Akshita mahajan', 'date': '19 Jan 2026', 'amount': '₹XXX'},
  ];

  void selectFilter(String f) => selectedFilter.value = f;
  void downloadInvoice() {}
  void pickMonth() {}
}
