import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/family_members_controller.dart';

class FamilyMembersView extends GetView<FamilyMembersController> {
  const FamilyMembersView({super.key});

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
        title: const Text('My Family Members',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== MEMBERS LIST =====
            Obx(() => Column(
                  children:
                      controller.members.map((m) => _memberCard(m)).toList(),
                )),
            const SizedBox(height: 14),

            // ===== ADD NEW MEMBER =====
            GestureDetector(
              onTap: controller.addNewMember,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF0D9488),
                    width: 1.5,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add_outlined,
                        color: Color(0xFF0D9488), size: 22),
                    SizedBox(width: 10),
                    Text('Add New Member',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF0D9488))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberCard(Map<String, dynamic> m) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      child: Row(
        children: [
          // Initials circle
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2F1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(m['initials'] as String,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D9488))),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m['name'] as String,
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              const SizedBox(height: 3),
              Text('${m['relation']}  |  PHIR ID: ${m['phirId']}',
                  style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF6B7280))),
            ],
          ),
        ],
      ),
    );
  }
}
