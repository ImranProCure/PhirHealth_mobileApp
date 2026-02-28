import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/my_profile_controller.dart';

class MyProfileView extends GetView<MyProfileController> {
  const MyProfileView({super.key});

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
          'My Profile',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: controller.openSettings,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== PROFILE CARD =====
                  _profileCard(),
                  const SizedBox(height: 16),

                  // ===== MENU SECTIONS =====
                  ...List.generate(controller.menuSections.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _menuSection(controller.menuSections[i]),
                    );
                  }),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // ===== LOG OUT BUTTON =====
          _logoutButton(),

          // ===== VERSION =====
          const Padding(
            padding: EdgeInsets.only(bottom: 24, top: 8),
            child: Text(
              'PHIR Health version 1.0.2',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 12,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== PROFILE CARD =====
  Widget _profileCard() {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 32,
                backgroundImage: AssetImage(controller.profileImage),
                backgroundColor: const Color(0xFFE0F2F1),
                onBackgroundImageError: (_, __) {},
              ),
              const SizedBox(width: 14),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.name,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      controller.phirId,
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
                          controller.phone,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const Text(
                          '  |  ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        Text(
                          controller.age,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Edit icon
              GestureDetector(
                onTap: controller.editProfile,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF0D9488), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Color(0xFF0D9488),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Blood Group Badge — center aligned
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF0D9488)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.water_drop_outlined,
                    size: 14,
                    color: Color(0xFF0D9488),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    controller.bloodGroup,
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
      ),
    );
  }

  // ===== MENU SECTION =====
  Widget _menuSection(List<Map<String, dynamic>> items) {
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
              _menuItem(item),
              if (!isLast)
                const Divider(
                  height: 1,
                  color: Color(0xFFF3F4F6),
                ),
            ],
          );
        }),
      ),
    );
  }

  // ===== MENU ITEM =====
  Widget _menuItem(Map<String, dynamic> item) {
    final String? trailing = item['trailing'] as String?;
    return GestureDetector(
      onTap: () => controller.onMenuTap(item['route'] as String),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon box
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
            // Label
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
            // Trailing text if any
            if (trailing != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  trailing,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            // Arrow
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  // ===== LOGOUT BUTTON =====
  Widget _logoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        onPressed: controller.logout,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 52),
          side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, color: Color(0xFFEF4444), size: 18),
            SizedBox(width: 8),
            Text(
              'Log Out',
              style: TextStyle(
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
