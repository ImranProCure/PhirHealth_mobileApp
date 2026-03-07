import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_profile_controller.dart';

class DoctorProfileView extends GetView<DoctorProfileController> {
  const DoctorProfileView({super.key});

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
        title: const Text('My Profile',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: controller.onShare,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== PROFILE CARD =====
            _profileCard(),
            const SizedBox(height: 14),

            // ===== SECTION 1: Availability + Clinic =====
            _menuCard(controller.section1),
            const SizedBox(height: 14),

            // ===== SECTION 2: Earnings + Reviews =====
            _menuCard(controller.section2),
            const SizedBox(height: 14),

            // ===== SECTION 3: Language + Help + Privacy =====
            _menuCard(controller.section4),
            const SizedBox(height: 20),

            // ===== LOGOUT =====
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: controller.logout,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                icon: const Icon(Icons.logout,
                    color: Color(0xFFEF4444), size: 20),
                label: const Text('Log Out',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFEF4444))),
              ),
            ),
            const SizedBox(height: 16),

            // ===== VERSION =====
            const Text('PHIR Health version 1.0.2',
                style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF9CA3AF))),
            const SizedBox(height: 16),
          ],
        ),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              ClipOval(
                child: Image.asset(
                  controller.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: const Color(0xFFE0F2F1),
                    child: const Icon(Icons.person,
                        color: Color(0xFF0D9488), size: 34),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.name,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                    const SizedBox(height: 2),
                    Text(controller.credentials,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280))),
                    const SizedBox(height: 2),
                    Text(controller.regNo,
                        style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280))),
                  ],
                ),
              ),
              // Edit icon
              GestureDetector(
                onTap: controller.onEdit,
                child: const Icon(Icons.edit_outlined,
                    color: Color(0xFF0D9488), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Online toggle
              Obx(() => Row(
                    children: [
                      Switch(
                        value: controller.isOnline.value,
                        onChanged: controller.toggleOnline,
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF0D9488),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFD1D5DB),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.isOnline.value ? 'Online' : 'Offline',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: controller.isOnline.value
                              ? const Color(0xFF0D9488)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  )),
              const SizedBox(width: 12),
              // Verified badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: const Color(0xFF0D9488), width: 1.5),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined,
                        color: Color(0xFF0D9488), size: 14),
                    SizedBox(width: 5),
                    Text('Verified Doctor',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D9488))),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== MENU CARD =====
  Widget _menuCard(List<Map<String, dynamic>> items) {
    return Container(
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
        children: List.generate(items.length, (i) {
          final item = items[i];
          final bool isLast = i == items.length - 1;
          return Column(
            children: [
              GestureDetector(
                onTap: () => controller.onTileRoute(item['route'] as String),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(
                    children: [
                      // Icon box
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0F2F1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9),
                          child: Image.asset(
                            item['iconPath'] as String,
                            fit: BoxFit.contain,
                            color: const Color(0xFF0D9488),
                            colorBlendMode: BlendMode.srcIn,
                            errorBuilder: (_, __, ___) => const Icon(
                                Icons.circle_outlined,
                                color: Color(0xFF0D9488),
                                size: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(item['label'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                      ),
                      // Trailing: rating star OR language value
                      if (item['trailing'] != null) ...[
                        const Icon(Icons.star,
                            color: Color(0xFFFBBF24), size: 16),
                        const SizedBox(width: 4),
                        Text(item['trailing'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.black)),
                        const SizedBox(width: 6),
                      ],
                      if (item['value'] != null) ...[
                        Text(item['value'] as String,
                            style: const TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Color(0xFF6B7280))),
                        const SizedBox(width: 6),
                      ],
                      const Icon(Icons.arrow_forward_ios,
                          size: 14, color: Color(0xFF9CA3AF)),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: Color(0xFFF3F4F6)),
            ],
          );
        }),
      ),
    );
  }
}
