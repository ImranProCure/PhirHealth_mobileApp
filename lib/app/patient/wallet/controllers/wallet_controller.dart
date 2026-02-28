import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final RxDouble balance = 1250.00.obs;

  // ===== TRANSACTIONS =====
  final List<Map<String, dynamic>> transactions = [
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

  void goToAddMoney() => Get.toNamed('/add-money');
  void viewAll() => Get.toNamed('/transaction-history');
  void referAndEarn() {}
  void myCoupons() => Get.toNamed('/savings-offers');
  void helpSupport() {}
}
