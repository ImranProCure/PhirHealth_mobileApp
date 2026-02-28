import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/transaction_history_controller.dart';

class TransactionHistoryView extends GetView<TransactionHistoryController> {
  const TransactionHistoryView({super.key});

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
          'Transaction History',
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
          // ===== FILTER TABS =====
          _filterTabs(),
          // ===== LIST =====
          Expanded(
            child: Obx(() {
              final data = controller.filteredTransactions;
              if (data.isEmpty) {
                return const Center(
                  child: Text(
                    'No transactions found',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                );
              }
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: data.map((group) {
                        return _transactionGroup(group);
                      }).toList(),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // ===== FILTER TABS =====
  Widget _filterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Obx(() => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: controller.filters.map((f) {
                final bool isSelected = controller.selectedFilter.value == f;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectFilter(f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        gradient: isSelected
                            ? const LinearGradient(
                                colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                              )
                            : null,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        f,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          )),
    );
  }

  Widget _transactionGroup(Map<String, dynamic> group) {
    final List items = group['items'] as List;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined,
                  size: 14, color: Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Text(
                group['month'] as String,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        ...List.generate(items.length, (i) {
          final item = items[i] as Map<String, dynamic>;
          final bool isLast = i == items.length - 1;
          return Column(
            children: [
              _transactionItem(item),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ],
    );
  }

  Widget _transactionItem(Map<String, dynamic> item) {
    final bool isDebit = item['isDebit'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF0D9488).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item['icon'] as IconData,
                size: 20, color: const Color(0xFF0D9488)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${item['date']}  .  ${item['time']}',
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['amount'] as String,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDebit
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item['id'] as String,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
