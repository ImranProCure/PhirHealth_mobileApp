import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactsController extends GetxController {
  final RxList<Map<String, dynamic>> contacts = <Map<String, dynamic>>[
    {
      'name': 'Kamlesh Singh',
      'relation': 'Son',
      'phone': '98765 32140',
      'iconBg': 0xFFEFF6FF,
      'iconColor': 0xFF3B82F6,
      'icon': Icons.group_outlined,
    },
    {
      'name': 'Dr. Smith',
      'relation': 'Cardiologist',
      'phone': '98765 32140',
      'iconBg': 0xFFF5F3FF,
      'iconColor': 0xFF8B5CF6,
      'icon': Icons.medical_services_outlined,
    },
    {
      'name': 'Kamlesh Singh',
      'relation': 'Spouse',
      'phone': '98765 32140',
      'iconBg': 0xFFFFF7ED,
      'iconColor': 0xFFF97316,
      'icon': Icons.face_outlined,
    },
  ].obs;

  void callAmbulance() async {
    final Uri uri = Uri(scheme: 'tel', path: '108');
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void callContact(String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void addNewContact() {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Add Emergency Contact',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              // Name field
              _buildField(
                controller: nameController,
                label: 'Full Name',
                hint: 'e.g. Kamlesh Singh',
                icon: Icons.person_outline,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              const SizedBox(height: 14),

              // Relation dropdown
              _buildDropdown(
                controller: relationController,
                label: 'Relation',
                icon: Icons.people_outline,
                items: const [
                  'Father',
                  'Mother',
                  'Spouse',
                  'Sibling',
                  'Family',
                  'Other'
                ],
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Relation required'
                    : null,
              ),
              const SizedBox(height: 14),

              // Phone field
              _buildField(
                controller: phoneController,
                label: 'Phone Number',
                hint: 'e.g. 98765 32140',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone required';
                  if (v.replaceAll(' ', '').length < 10) {
                    return 'Enter valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      contacts.add({
                        'name': nameController.text.trim(),
                        'relation': relationController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'iconBg': 0xFFE0F2F1,
                        'iconColor': 0xFF0D9488,
                        'icon': Icons.person_outline,
                      });
                      Get.back();
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Get.snackbar(
                          'Contact Added',
                          '${nameController.text.trim()} added successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF0D9488),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save Contact',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> items,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: controller.text.isEmpty ? null : controller.text,
          validator: validator,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 14,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF0D9488), size: 20),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
          dropdownColor: Colors.white,
          hint: const Text(
            'Select relation',
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Color(0xFFD1D5DB),
            ),
          ),
          items: items
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      e,
                      style: const TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ))
              .toList(),
          onChanged: (val) {
            if (val != null) controller.text = val;
          },
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 14,
              color: Color(0xFFD1D5DB),
            ),
            prefixIcon: Icon(icon, color: const Color(0xFF0D9488), size: 20),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
