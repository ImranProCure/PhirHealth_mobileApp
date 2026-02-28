import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SavingsOffersController extends GetxController {
  final RxInt selectedTab = 0.obs;

  void selectTab(int index) => selectedTab.value = index;

  // ===== MEDICINE OFFERS DATA =====
  final List<Map<String, dynamic>> medicineOffers = [
    {
      'badge': 'NEW USER OFFER',
      'badgeColor': 0xFFFFB800,
      'title': 'FLAT 25% OFF',
      'subtitle': 'On your first medicine order',
      'minOrder': 'Min Order: 500  |  Code: FIRST25',
      'buttonLabel': 'Apply Now',
      'buttonType': 'apply',
      'verified': false,
      'expiry': '',
      'code': 'FIRST25',
    },
    {
      'badge': '',
      'badgeColor': 0xFF0D9488,
      'title': '₹100 OFF',
      'subtitle': 'On orders above ₹999',
      'minOrder': '',
      'buttonLabel': 'Copy Code',
      'buttonType': 'copy',
      'verified': true,
      'expiry': '',
      'code': 'PHIR100',
    },
    {
      'badge': '',
      'badgeColor': 0xFF0D9488,
      'title': 'Free Health Check',
      'subtitle':
          'Complimentary Vitamin D test with any full body screening package',
      'minOrder': '',
      'buttonLabel': 'View Package',
      'buttonType': 'view',
      'verified': false,
      'expiry': 'EXPIRES IN 2 DAYS',
      'code': '',
    },
  ];

  // ===== LAB TEST OFFERS DATA =====
  final List<Map<String, dynamic>> labTestOffers = [
    {
      'badge': 'LIMITED OFFER',
      'badgeColor': 0xFF10B981,
      'title': 'FLAT 30% OFF',
      'subtitle': 'On all lab test packages',
      'minOrder': 'Min Order: 299  |  Code: LAB30',
      'buttonLabel': 'Apply Now',
      'buttonType': 'apply',
      'verified': false,
      'expiry': '',
      'code': 'LAB30',
    },
    {
      'badge': '',
      'badgeColor': 0xFF0D9488,
      'title': '₹200 OFF',
      'subtitle': 'On full body checkup above ₹1499',
      'minOrder': '',
      'buttonLabel': 'Copy Code',
      'buttonType': 'copy',
      'verified': true,
      'expiry': '',
      'code': 'BODY200',
    },
    {
      'badge': '',
      'badgeColor': 0xFF0D9488,
      'title': 'Free Home Collection',
      'subtitle': 'On any lab test booking above ₹499',
      'minOrder': '',
      'buttonLabel': 'View Packages',
      'buttonType': 'view',
      'verified': false,
      'expiry': 'EXPIRES IN 5 DAYS',
      'code': '',
    },
  ];

  List<Map<String, dynamic>> get currentOffers =>
      selectedTab.value == 0 ? medicineOffers : labTestOffers;

  void handleButton(Map<String, dynamic> offer) {
    final String type = offer['buttonType'] as String;
    if (type == 'copy') {
      Clipboard.setData(ClipboardData(text: offer['code'] as String));
      Get.snackbar(
        'Copied!',
        'Code ${offer['code']} copied to clipboard',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else if (type == 'apply') {
      Get.snackbar(
        'Applied!',
        'Code ${offer['code']} applied successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } else {
      Get.snackbar(
        'Packages',
        'Opening packages...',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0D9488),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
