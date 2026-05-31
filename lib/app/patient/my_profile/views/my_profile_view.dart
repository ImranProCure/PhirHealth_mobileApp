import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/db/db.dart';
import '../../../common widgets/lang_toggle.dart'; // ← apna actual path daalo
import '../controllers/my_profile_controller.dart';

// ─────────────────────────────────────────────
// Breakpoint helper
// ─────────────────────────────────────────────
bool _isTablet(BuildContext context) =>
    MediaQuery.of(context).size.shortestSide >= 600;

// ═══════════════════════════════════════════════════════════
//  ROOT VIEW
// ═══════════════════════════════════════════════════════════
class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return _isTablet(context)
        ? _TabletMyProfileView(controller: controller)
        : _PhoneMyProfileView(controller: controller);
  }
}

// ═══════════════════════════════════════════════════════════
//  PHONE LAYOUT
// ═══════════════════════════════════════════════════════════
class _PhoneMyProfileView extends StatelessWidget {
  final MyProfileController controller;
  const _PhoneMyProfileView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(controller, fontSize: 16),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _ProfileCard(controller: controller),
                  const SizedBox(height: 16),
                  // CHANGED: Obx wrap — locale change hone pe menu labels retranslate hon
                  Obx(() {
                    // isHindiGlobal read karna zaroori hai taaki Obx rebuild trigger ho
                    isHindiGlobal.value;
                    return Column(
                      children: [
                        ...List.generate(controller.menuSections.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _MenuSection(
                                controller: controller,
                                items: controller.menuSections[i]),
                          );
                        }),
                        const SizedBox(height: 8),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
          _LogoutButton(controller: controller),
          const Padding(
            padding: EdgeInsets.only(bottom: 24, top: 8),
            child: _VersionText(),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  TABLET LAYOUT
// ═══════════════════════════════════════════════════════════
class _TabletMyProfileView extends StatelessWidget {
  final MyProfileController controller;
  const _TabletMyProfileView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: _buildAppBar(controller, fontSize: 18),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.36,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: AssetImage(controller.profileImage),
                    backgroundColor: const Color(0xFFE0F2F1),
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.phirId,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${controller.phone}  |  ${controller.age}',
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF0D9488)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.water_drop_outlined,
                            size: 16, color: Color(0xFF0D9488)),
                        const SizedBox(width: 6),
                        Text(
                          controller.bloodGroup,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: controller.editProfile,
                    icon: const Icon(Icons.edit_outlined,
                        size: 16, color: Color(0xFF0D9488)),
                    label: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D9488),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 46),
                      side: const BorderSide(
                          color: Color(0xFF0D9488), width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  const Spacer(),
                  _LogoutButton(controller: controller),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24, top: 10),
                    child: _VersionText(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(controller.menuSections.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _MenuSection(
                          controller: controller,
                          items: controller.menuSections[i]),
                    );
                  }),
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

AppBar _buildAppBar(MyProfileController controller,
    {required double fontSize}) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    scrolledUnderElevation: 0.0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
      onPressed: () => Get.back(),
    ),
    centerTitle: true,
    title: Text(
      'patient_menu_title'.tr,
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    ),
    actions: const [],
  );
}

// ── Profile Card ──────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final MyProfileController controller;
  _ProfileCard({required this.controller});
  final authStorage = AuthStorageService();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
        child: FutureBuilder(
            future: authStorage.getUserDetail(),
            builder: (context, snapshot) {
              final fullName = snapshot.data?['full_name'] ?? '';
              final image = snapshot.data?['user_image'] ?? '';
              final mobile = snapshot.data?['mobile_no'] ?? '';
              final email = snapshot.data?['email'] ?? '';
              final dob = snapshot.data?['birth_date'] ?? '';
              final gender = snapshot.data?['gender'] ?? '';
              final bgroup = controller
                  .getBloodGroupFullName(snapshot.data?['blood_group'] ?? '');

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage:
                            NetworkImage("${ApiConstants.baseUrl}$image"),
                        backgroundColor: const Color(0xFFE0F2F1),
                        onBackgroundImageError: (_, __) {},
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              controller.maskEmail(email),
                              style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Text(
                                  "+91 ${controller.maskMobile(mobile)}",
                                  style: const TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                                const Text('  |  ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF6B7280))),
                                Text("${controller.calculateAge(dob)}$gender",
                                    style: const TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: Color(0xFF6B7280))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: controller.editProfile,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF0D9488), width: 1.5),
                          ),
                          child: const Icon(Icons.edit_outlined,
                              size: 16, color: Color(0xFF0D9488)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF0D9488)),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.water_drop_outlined,
                              size: 14, color: Color(0xFF0D9488)),
                          const SizedBox(width: 6),
                          Text(
                            '${'patient_step1_blood_group'.tr}: $bgroup',
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0D9488),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }));
  }
}

// ── Menu Section ──────────────────────────────────────────
class _MenuSection extends StatelessWidget {
  final MyProfileController controller;
  final List<Map<String, dynamic>> items;
  const _MenuSection({required this.controller, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: List.generate(items.length, (i) {
          final item = items[i];
          final bool isLast = i == items.length - 1;
          return Column(
            children: [
              _MenuItem(controller: controller, item: item),
              if (!isLast) const Divider(height: 1, color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }
}

// ── Menu Item ─────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final MyProfileController controller;
  final Map<String, dynamic> item;
  const _MenuItem({required this.controller, required this.item});

  @override
  Widget build(BuildContext context) {
    // CHANGED: 'trailing' hata ke 'isLangItem' flag se detect karo
    final bool isLangItem = item['isLangItem'] == true;

    return GestureDetector(
      onTap: () => controller.onMenuTap(item['route'] as String),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: item['iconBg'] as Color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item['icon'] as IconData,
                size: 20,
                color: item['iconColor'] as Color,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item['label'] as String,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            if (isLangItem)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Obx(() => Text(
                      isHindiGlobal.value ? 'हिंदी' : 'English',
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 13,
                        color: Color(0xFF9CA3AF),
                      ),
                    )),
              ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Color(0xFF9CA3AF)),
          ],
        ),
      ),
    );
  }
}

// ── Logout Button ─────────────────────────────────────────
class _LogoutButton extends StatelessWidget {
  final MyProfileController controller;
  const _LogoutButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        onPressed: controller.logout,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Color(0xFFEF4444), size: 18),
            const SizedBox(width: 8),
            Text(
              'patient_logout_title'.tr,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Version Text ──────────────────────────────────────────
class _VersionText extends StatelessWidget {
  const _VersionText();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'PHIR Health version 1.0.0',
      style: TextStyle(
        fontFamily: 'Mulish',
        fontSize: 12,
        color: Color(0xFF9CA3AF),
      ),
    );
  }
}
