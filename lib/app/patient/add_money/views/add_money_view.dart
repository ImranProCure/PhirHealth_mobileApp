import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/add_money_controller.dart';

class AddMoneyView extends GetView<AddMoneyController> {
  const AddMoneyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Add Money',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== AMOUNT CARD =====
                  _amountCard(),
                  const SizedBox(height: 16),
                  // ===== PAYMENT METHODS =====
                  _paymentMethods(),
                ],
              ),
            ),
          ),
          // ===== PROCEED BUTTON =====
          _proceedButton(),
        ],
      ),
    );
  }

  // ===== AMOUNT CARD =====
  Widget _amountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Enter Amount to Add',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),

          // ₹ + Input
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '₹',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              IntrinsicWidth(
                child: TextField(
                  controller: controller.amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: controller.onAmountChanged,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0D9488)),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.only(bottom: 4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Quick amount chips
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.quickAmounts.map((amt) {
                  final bool isSelected =
                      controller.amount.value == amt.toString();
                  return GestureDetector(
                    onTap: () => controller.selectQuickAmount(amt),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF0D9488).withOpacity(0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFE5E7EB),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Text(
                        '+₹${amt >= 1000 ? '${(amt / 1000).toStringAsFixed(0)},000' : amt}',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    );
  }

  // ===== PAYMENT METHODS =====
  Widget _paymentMethods() {
    return Obx(() => Column(
          children: controller.paymentMethods.map((method) {
            final bool isSelected =
                controller.selectedPayment.value == method['name'];
            return GestureDetector(
              onTap: () => controller.selectPayment(method['name'] as String),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Payment icon
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: _paymentIcon(method),
                    ),
                    const SizedBox(width: 14),
                    // Name
                    Expanded(
                      child: Text(
                        method['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Radio
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF0D9488)
                              : const Color(0xFFD1D5DB),
                          width: 1.5,
                        ),
                        color: isSelected
                            ? const Color(0xFF0D9488)
                            : Colors.transparent,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check,
                              size: 13, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ));
  }

  Widget _paymentIcon(Map<String, dynamic> method) {
    final String name = method['name'] as String;
    switch (name) {
      case 'Google Pay':
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Center(
            child: Text(
              'G Pay',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
          ),
        );
      case 'PhonePe':
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF5F259F),
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'Pe',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        );
      case 'Paytm':
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF002970),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: const Center(
            child: Text(
              'Ptm',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        );
      case 'Credit / Debit Cards':
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0D9488).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.credit_card_outlined,
            color: Color(0xFF0D9488),
            size: 22,
          ),
        );
      default:
        return const SizedBox();
    }
  }

  // ===== PROCEED BUTTON =====
  Widget _proceedButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      child: Obx(() => SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                ),
              ),
              child: ElevatedButton(
                onPressed: controller.proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance_outlined,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Proceed to Pay ₹${controller.amount.value}',
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
