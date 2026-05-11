import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sample/app/service/api/common_api/emergency_contact_api/emergency_contact_api.dart';

class EmergencyContactsController extends GetxController {
  // ─────────────────────────────────────────────
  // CHANGE 1: Static hardcoded list hata di
  // Ab empty list hai — data API se aayega
  // ─────────────────────────────────────────────
  final RxList<Map<String, dynamic>> contacts = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  final EmergencyContactApi _api = EmergencyContactApi();

  // ─────────────────────────────────────────────
  // CHANGE 2: onInit add kiya
  // Screen open hote hi GET call hogi automatically
  // ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchContacts();
  }

  // ─────────────────────────────────────────────
  // CHANGE 3: fetchContacts() naya function
  // GET API call — response se contacts list fill hoti hai
  // ─────────────────────────────────────────────
  Future<void> fetchContacts() async {
    isLoading.value = true;
    final response = await _api.getEmergencyContacts();
    isLoading.value = false;

    if (response.status) {
      final data = response.data['message']['data'] as List;
      contacts.value = data
          .map((e) => {
                'name': e['contact_name'],
                'relation': e['relation'],
                'phone': e['phone_number'],
                'iconBg': 0xFFEFF6FF,
                'iconColor': 0xFF3B82F6,
                'icon': Icons.person_outline,
              })
          .toList();
    } else {
      // Sirf error pe snackbar — success pe kuch nahi
      Get.snackbar(
        'Error',
        response.message ?? 'Failed to fetch contacts',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

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
              _buildField(
                controller: nameController,
                label: 'Full Name',
                hint: 'e.g. Kamlesh Singh',
                icon: Icons.person_outline,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              const SizedBox(height: 14),
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
              // ─────────────────────────────────────────────
              // CHANGE 4: maxLength: 10 add kiya phone field mein
              // User 10 se zyada digits type nahi kar sakta
              // ─────────────────────────────────────────────
              _buildField(
                controller: phoneController,
                label: 'Phone Number',
                hint: 'e.g. 9876543210',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Phone required';
                  // CHANGE 5: < 10 ki jagah != 10 — exactly 10 digits chahiye
                  if (v.replaceAll(' ', '').length != 10) {
                    return 'Enter valid 10 digit number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      // Sheet band karo pehle — smooth UX
                      Get.back();

                      // ─────────────────────────────────────────────
                      // CHANGE 6: Optimistic update
                      // POST ka wait nahi — pehle locally list mein add karo
                      // Taaki user ko instant feedback mile
                      // ─────────────────────────────────────────────
                      contacts.add({
                        'name': nameController.text.trim(),
                        'relation': relationController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'iconBg': 0xFFE0F2F1,
                        'iconColor': 0xFF0D9488,
                        'icon': Icons.person_outline,
                      });

                      // Ab POST API call karo background mein
                      final response = await _api.addEmergencyContact(
                        contactName: nameController.text.trim(),
                        relation: relationController.text.trim(),
                        phoneNumber:
                            phoneController.text.trim().replaceAll(' ', ''),
                      );

                      if (response.status) {
                        // ─────────────────────────────────────────────
                        // CHANGE 7: Success toast/snackbar hata diya
                        // Sirf fresh data fetch karo API se
                        // ─────────────────────────────────────────────
                        fetchContacts();
                      } else {
                        // ─────────────────────────────────────────────
                        // CHANGE 8: Agar POST fail ho
                        // Locally jo add kiya tha usse wapas hata do
                        // Aur error dikhao
                        // ─────────────────────────────────────────────
                        contacts.removeLast();
                        Get.snackbar(
                          'Error',
                          response.message ?? 'Failed to add contact',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFFEF4444),
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          borderRadius: 12,
                        );
                      }
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
    // CHANGE 9: maxLength parameter add kiya
    int? maxLength,
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
          maxLength: maxLength, // CHANGE 9: yahan pass kiya
          validator: validator,
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            // CHANGE 10: counter hide kiya taaki "0/10" UI mein na dikhe
            counterText: '',
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
