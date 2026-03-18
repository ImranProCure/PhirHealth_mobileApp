import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_controller.dart';

// ─────────────────────────────────────────────
// Breakpoint helper
// ─────────────────────────────────────────────
bool _isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= 600;

// ═══════════════════════════════════════════════════════════
//  ROOT VIEW
// ═══════════════════════════════════════════════════════════
class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return _isTablet(context)
        ? _TabletWalletView(controller: controller)
        : _PhoneWalletView(controller: controller);
  }
}

// ═══════════════════════════════════════════════════════════
//  PHONE LAYOUT  (original — untouched)
// ═══════════════════════════════════════════════════════════
class _PhoneWalletView extends StatelessWidget {
  final WalletController controller;
  const _PhoneWalletView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(fontSize: 16),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BalanceCard(controller: controller),
            const SizedBox(height: 16),
            _AddMoneyButton(controller: controller),
            const SizedBox(height: 8),
            const _SafeSecureLabel(),
            const SizedBox(height: 20),
            _QuickActions(controller: controller),
            const SizedBox(height: 24),
            _TransactionHeader(controller: controller),
            const SizedBox(height: 12),
            _TransactionList(controller: controller),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TABLET LAYOUT
// ═══════════════════════════════════════════════════════════
class _TabletWalletView extends StatelessWidget {
  final WalletController controller;
  const _TabletWalletView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(fontSize: 18),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── LEFT: Balance + actions ───────────────────────
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.38,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2F1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Health Wallet',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'My Wallet',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Balance card — full width in panel
                  _BalanceCard(controller: controller),
                  const SizedBox(height: 16),

                  // Add money
                  _AddMoneyButton(controller: controller),
                  const SizedBox(height: 8),
                  const _SafeSecureLabel(),
                  const SizedBox(height: 28),

                  // Quick actions — vertical on tablet
                  _QuickActionsVertical(controller: controller),
                ],
              ),
            ),
          ),

          // ── RIGHT: Transactions ───────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TransactionHeader(controller: controller),
                  const SizedBox(height: 12),
                  _TransactionList(controller: controller),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════

AppBar _buildAppBar({required double fontSize}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () => Get.back(),
    ),
    centerTitle: true,
    title: Text(
      'My Health Wallet',
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
  );
}

// ── Balance Card ──────────────────────────────────────────
class _BalanceCard extends StatelessWidget {
  final WalletController controller;
  const _BalanceCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF00897B), Color(0xFF1565C0)],
        ),
      ),
      child: Obx(() => Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Balance',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹ ${controller.balance.value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}

// ── Add Money Button ──────────────────────────────────────
class _AddMoneyButton extends StatelessWidget {
  final WalletController controller;
  const _AddMoneyButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: controller.goToAddMoney,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        side: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle_outline,
              color: Color(0xFF0D9488), size: 20),
          SizedBox(width: 8),
          Text(
            'Add Money to Wallet',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D9488),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Safe & Secure Label ───────────────────────────────────
class _SafeSecureLabel extends StatelessWidget {
  const _SafeSecureLabel();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.account_balance_outlined,
              size: 14, color: Color(0xFF6B7280)),
          SizedBox(width: 6),
          Text(
            '100% Safe & Secure',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Actions — horizontal (phone) ───────────────────
class _QuickActions extends StatelessWidget {
  final WalletController controller;
  const _QuickActions({required this.controller});

  @override
  Widget build(BuildContext context) {
    final actions = _quickActionItems(controller);
    return Row(
      children: actions.map((a) {
        return Expanded(
          child: GestureDetector(
            onTap: a['onTap'] as VoidCallback,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                children: [
                  Icon(a['icon'] as IconData,
                      color: const Color(0xFF0D9488), size: 28),
                  const SizedBox(height: 8),
                  Text(
                    a['label'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Quick Actions — vertical (tablet left panel) ─────────
class _QuickActionsVertical extends StatelessWidget {
  final WalletController controller;
  const _QuickActionsVertical({required this.controller});

  @override
  Widget build(BuildContext context) {
    final actions = _quickActionItems(controller);
    return Column(
      children: actions.map((a) {
        return GestureDetector(
          onTap: a['onTap'] as VoidCallback,
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 10),
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFE5E7EB), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488).withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(a['icon'] as IconData,
                      color: const Color(0xFF0D9488), size: 22),
                ),
                const SizedBox(width: 14),
                Text(
                  a['label'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios,
                    size: 14, color: Color(0xFF9CA3AF)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Shared action items builder ───────────────────────────
List<Map<String, dynamic>> _quickActionItems(WalletController c) => [
      {
        'icon': Icons.celebration_outlined,
        'label': 'Refer & Earn',
        'onTap': c.referAndEarn,
      },
      {
        'icon': Icons.confirmation_num_outlined,
        'label': 'My Coupons',
        'onTap': c.myCoupons,
      },
      {
        'icon': Icons.headset_mic_outlined,
        'label': 'Help/Support',
        'onTap': c.helpSupport,
      },
    ];

// ── Transaction Header ────────────────────────────────────
class _TransactionHeader extends StatelessWidget {
  final WalletController controller;
  const _TransactionHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Last Transactions',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: controller.viewAll,
          child: const Text(
            'View All',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0D9488),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Transaction List ──────────────────────────────────────
class _TransactionList extends StatelessWidget {
  final WalletController controller;
  const _TransactionList({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: controller.transactions
            .map((group) => _TransactionGroup(group: group))
            .toList(),
      ),
    );
  }
}

// ── Transaction Group ─────────────────────────────────────
class _TransactionGroup extends StatelessWidget {
  final Map<String, dynamic> group;
  const _TransactionGroup({required this.group});

  @override
  Widget build(BuildContext context) {
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
              _TransactionItem(item: item),
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
}

// ── Transaction Item ──────────────────────────────────────
class _TransactionItem extends StatelessWidget {
  final Map<String, dynamic> item;
  const _TransactionItem({required this.item});

  @override
  Widget build(BuildContext context) {
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
            child: Icon(
              item['icon'] as IconData,
              size: 20,
              color: const Color(0xFF0D9488),
            ),
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
                  '${item['date']}  ·  ${item['time']}',
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