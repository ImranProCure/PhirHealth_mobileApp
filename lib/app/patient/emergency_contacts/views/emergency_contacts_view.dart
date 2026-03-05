import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/emergency_contacts_controller.dart';

class EmergencyContactsView extends GetView<EmergencyContactsController> {
  const EmergencyContactsView({super.key});

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
          'Emergency Contacts',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== EMERGENCY CARD =====
            _emergencyCard(),
            const SizedBox(height: 24),

            // ===== TRUSTED CONTACTS =====
            const Text(
              'My Trusted Contacts',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            ...controller.contacts.map((c) => _contactTile(c)),
            const SizedBox(height: 8),

            // ===== ADD NEW CONTACT =====
            _addNewContact(),
          ],
        ),
      ),
    );
  }

  Widget _emergencyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFCDD2), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'In case of emergency, these numbers\nwill be dialled.',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              color: Color(0xFF374151),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_hospital_outlined,
                  color: Color(0xFFEF4444),
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Medical Emergency',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                  Text(
                    'Priority Access',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 12,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                '108',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFFEF4444),
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: controller.callAmbulance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  icon: const Icon(Icons.phone, color: Colors.white, size: 16),
                  label: const Text(
                    'Call Ambulance',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactTile(Map<String, dynamic> contact) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(contact['iconBg'] as int),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              contact['icon'] as IconData,
              color: Color(contact['iconColor'] as int),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact['name'] as String,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${contact['relation']} | ${contact['phone']}',
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.callContact(contact['phone'] as String),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.phone, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addNewContact() {
    return GestureDetector(
      onTap: controller.addNewContact,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF0D9488),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF0D9488).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.person_add_outlined,
                color: Color(0xFF0D9488),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Add New Contact',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
