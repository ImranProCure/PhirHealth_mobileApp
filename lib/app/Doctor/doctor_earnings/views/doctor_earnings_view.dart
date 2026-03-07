import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_earnings_controller.dart';

class DoctorEarningsView extends GetView<DoctorEarningsController> {
  const DoctorEarningsView({super.key});

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
        title: const Text('Earning Summary',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TOTAL EARNINGS CARD =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined,
                      color: Colors.white, size: 44),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Earning - Since joining',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(controller.totalEarnings,
                          style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ===== WEEK + MONTH CARDS =====
            Row(
              children: [
                Expanded(
                    child: _summaryCard('This Week\'s Earnings',
                        controller.weekEarnings, controller.weekGrowth)),
                const SizedBox(width: 12),
                Expanded(
                    child: _summaryCard('This Month\'s Earnings',
                        controller.monthEarnings, controller.monthGrowth)),
              ],
            ),
            const SizedBox(height: 14),

            // ===== DOWNLOAD INVOICE =====
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: controller.downloadInvoice,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.receipt_long_outlined,
                    color: Color(0xFF0D9488), size: 20),
                label: const Text('Download Invoice',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488))),
              ),
            ),
            const SizedBox(height: 16),

            // ===== TRANSACTION HISTORY CARD =====
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transaction History',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.black)),
                      GestureDetector(
                        onTap: controller.pickMonth,
                        child: Row(
                          children: [
                            const Text('Feb, 2026',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                            const SizedBox(width: 6),
                            const Icon(Icons.calendar_month_outlined,
                                color: Color(0xFF0D9488), size: 18),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ===== FILTER CHIPS =====
                  Obx(() => Row(
                        children: controller.filters.map((f) {
                          final bool isSelected =
                              controller.selectedFilter.value == f;
                          return GestureDetector(
                            onTap: () => controller.selectFilter(f),
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 7),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0D9488)
                                      : const Color(0xFFE5E7EB),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(f,
                                  style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? const Color(0xFF0D9488)
                                        : Colors.black,
                                  )),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 14),

                  // ===== TRANSACTIONS LIST =====
                  ...List.generate(controller.transactions.length, (i) {
                    final t = controller.transactions[i];
                    final bool isLast = i == controller.transactions.length - 1;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              // Arrow icon box
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.south_west_rounded,
                                    color: Color(0xFF0D9488), size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Received from',
                                        style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 12,
                                            color: Color(0xFF9CA3AF))),
                                    Text(t['name']!,
                                        style: const TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(t['amount']!,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black)),
                                  Text(t['date']!,
                                      style: const TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 12,
                                          color: Color(0xFF9CA3AF))),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          const Divider(height: 1, color: Color(0xFFF3F4F6)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== SUMMARY CARD =====
  Widget _summaryCard(String title, String amount, String growth) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280))),
          const SizedBox(height: 6),
          Text(amount,
              style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.arrow_upward,
                  color: Color(0xFF0D9488), size: 13),
              const SizedBox(width: 2),
              Text(growth,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      color: Color(0xFF0D9488),
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
