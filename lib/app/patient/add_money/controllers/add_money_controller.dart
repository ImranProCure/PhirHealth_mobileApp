import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddMoneyController extends GetxController {
  final RxString amount = '500'.obs;
  final RxString selectedPayment = 'PhonePe'.obs;
  final TextEditingController amountController =
      TextEditingController(text: '500');

  final List<int> quickAmounts = [100, 500, 1000];

  final List<Map<String, dynamic>> paymentMethods = [
    {'name': 'Google Pay', 'icon': 'assets/icons/gpay.png', 'useAsset': true},
    {'name': 'PhonePe', 'icon': 'assets/icons/phonepe.png', 'useAsset': true},
    {'name': 'Paytm', 'icon': 'assets/icons/paytm.png', 'useAsset': true},
    {'name': 'Credit / Debit Cards', 'icon': null, 'useAsset': false},
  ];

  void selectQuickAmount(int val) {
    amount.value = val.toString();
    amountController.text = val.toString();
  }

  void selectPayment(String name) => selectedPayment.value = name;

  void onAmountChanged(String val) => amount.value = val;

  void proceed() {
    final int amt = int.tryParse(amount.value) ?? 0;
    if (amt <= 0) {
      Get.snackbar('Error', 'Please enter a valid amount',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12);
      return;
    }
    Get.back();
    Get.snackbar(
      'Success!',
      '₹$amt added to your wallet via ${selectedPayment.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
