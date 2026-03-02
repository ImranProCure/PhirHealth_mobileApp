import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/completion_controller.dart';

class CompletionView extends GetView<CompletionController> {
  const CompletionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Step 6 of 6 : Final Setup & Permissions',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body:SafeArea(
        bottom: true,
        child:  SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Completion',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            const SizedBox(height: 15),

            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 6 / 6,
                minHeight: 8,
                backgroundColor: Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
              ),
            ),

            const SizedBox(height: 30),

            // ================= SECURE & PRIVATE CARD =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE6F5F3),
                    Color(0xFFEAF2FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD1D5DB),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Secure & Private',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your information is protected with hospital-grade encryption.',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= EMERGENCY CONTACT =================
            const Text(
              'Emergency Contact',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Contact Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 10),

            _inputField(
              controller: controller.contactNameController,
              hint: 'Full Legal name',
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                // ================= RELATIONSHIP =================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Relationship",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          decoration: _inputDecoration("Spouse"),
                          value: controller.selectedRelationship.value.isEmpty
                              ? null
                              : controller.selectedRelationship.value,
                          items: controller.relationships
                              .map(
                                (item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(item),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.selectRelationship(value ?? '');
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // ================= MOBILE NUMBER =================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mobile Number",
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 60,
                        child: TextField(
                          controller: controller.mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: _inputDecoration("+91 9876543210"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Obx(() => CheckboxListTile(
                  value: controller.authorizeEmergency.value,
                  onChanged: (_) => controller.toggleAuthorize(),
                  title: const Text(
                    'I authorize PHIR health to share my critical medical profile in case of emergency.',
                    style: TextStyle(fontSize: 13),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                )),

            const SizedBox(height: 30),

            const Divider(
              thickness: 1,
              color: Color.fromARGB(255, 183, 185, 188),
            ),

            // ================= PERMISSIONS =================
            const SizedBox(height: 30),

            const Text(
              'App Permissions',
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 20),

            Obx(() => Column(
                  children: [
                    _permissionCard(
                      title: 'Medical Data Processing',
                      subtitle: 'Allow AI analysis of your records',
                      value: controller.allowMedicalProcessing.value,
                      onChanged: (val) =>
                          controller.allowMedicalProcessing.value = val,
                    ),
                    const SizedBox(height: 16),
                    _permissionCard(
                      title: 'Share with Doctors & Labs',
                      subtitle: 'Sync with your healthcare providers',
                      value: controller.shareWithDoctors.value,
                      onChanged: (val) =>
                          controller.shareWithDoctors.value = val,
                    ),
                    const SizedBox(height: 16),
                    _permissionCard(
                      title: 'Enable Health Reminders',
                      subtitle: 'Push notifications for meds & tasks',
                      value: controller.enableReminders.value,
                      onChanged: (val) =>
                          controller.enableReminders.value = val,
                    ),
                  ],
                )),

            const SizedBox(height: 30),

            Obx(() => _termsBox(
                  value: controller.acceptTerms.value,
                  onTap: controller.toggleTerms,
                )),
            const SizedBox(height: 30),

            // ================= COMPLETE BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 56,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF00786F),
                      Color(0xFF009689),
                      Color(0xFF1447E6),
                    ],
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: controller.completeProfile,
                  child: const Text(
                    'Complete Profile',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    ));
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
    );
  }

  // ================= PERMISSION TILE =================
  Widget _permissionCard({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Left Icon Box
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F5F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: Color(0xFF0D9488),
            ),
          ),

          const SizedBox(width: 16),

          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          // Switch
          Switch(
            value: value,
            activeColor: const Color(0xFF0D9488),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  // ================= TERMS BOX =================
  Widget _termsBox({
    required bool value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE6F5F3),
              Color(0xFFEAF2FF),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD1D5DB),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Checkbox
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color:
                      value ? const Color(0xFF0D9488) : const Color(0xFF6B7280),
                  width: 1.5,
                ),
                color: value ? const Color(0xFF0D9488) : Colors.transparent,
              ),
              child: value
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'I have read and agree to the ',
                    ),
                    TextSpan(
                      text: 'Terms of Service',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text:
                          '. I understand how my health data is stored and managed.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
