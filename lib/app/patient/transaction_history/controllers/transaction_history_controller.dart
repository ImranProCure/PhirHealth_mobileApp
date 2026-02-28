import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryController extends GetxController {
  final RxString selectedFilter = 'All'.obs;
  final List<String> filters = ['All', 'Money In', 'Money Out'];

  final List<Map<String, dynamic>> allTransactions = [
    {
      'month': 'February, 2026',
      'items': [
        {
          'title': 'Paid for Lab Test',
          'date': 'Feb 11, 2026',
          'time': '02:00 PM',
          'amount': '-₹1500',
          'id': 'ID: #PH9089',
          'isDebit': true,
          'icon': Icons.science_outlined,
        },
        {
          'title': 'Money added',
          'date': 'Feb 12, 2026',
          'time': '04:17 PM',
          'amount': '+₹1000',
          'id': 'ID: #PH9089',
          'isDebit': false,
          'icon': Icons.currency_rupee,
        },
      ],
    },
    {
      'month': 'January, 2026',
      'items': [
        {
          'title': 'Paid for Medicine',
          'date': 'Jan 24, 2026',
          'time': '10:30 AM',
          'amount': '-₹450',
          'id': 'ID: #PH8921',
          'isDebit': true,
          'icon': Icons.medication_outlined,
        },
        {
          'title': 'Paid for Medicine',
          'date': 'Jan 31, 2026',
          'time': '11:30 AM',
          'amount': '-₹150',
          'id': 'ID: #PH9021',
          'isDebit': true,
          'icon': Icons.medication_outlined,
        },
      ],
    },
  ];

  List<Map<String, dynamic>> get filteredTransactions {
    if (selectedFilter.value == 'All') return allTransactions;

    final bool wantDebit = selectedFilter.value == 'Money Out';
    return allTransactions
        .map((group) {
          final filtered = (group['items'] as List)
              .where((item) => (item['isDebit'] as bool) == wantDebit)
              .toList();
          return {'month': group['month'], 'items': filtered};
        })
        .where((g) => (g['items'] as List).isNotEmpty)
        .toList();
  }

  void selectFilter(String f) => selectedFilter.value = f;
}
