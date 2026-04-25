import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/clinical_capacity_controller.dart';

class ClinicalCapacityView extends GetView<ClinicalCapacityController> {
  const ClinicalCapacityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(Icons.chevron_left, size: 28, color: Colors.black),
        ),
        title: const Text(
          'Step 2 of 4',
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Optimizing Clinical Capacity',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(2),
                  const SizedBox(height: 24),

                  // Total Licensed Beds
                  _buildLabel('Total Licensed Beds'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.totalBedsController,
                    hint: 'e.g',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  // Toggle Cards
                  _buildServiceToggleCard(
                    icon: Icons.local_hospital_outlined,
                    title: 'ICU Availability',
                    subtitle: 'Intensive Care Units',
                    rxValue: controller.icuAvailability,
                    onChanged: (v) => controller.icuAvailability.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.emergency_outlined,
                    title: 'Emergency Services (24x7)',
                    subtitle: 'Round-the-clock Trauma',
                    rxValue: controller.emergencyServices,
                    onChanged: (v) => controller.emergencyServices.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.medical_services_outlined,
                    title: 'Operation Theatres',
                    subtitle: 'Available Theatres',
                    rxValue: controller.operationTheatres,
                    onChanged: (v) => controller.operationTheatres.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.biotech_outlined,
                    title: 'Diagnostic Facilities',
                    subtitle: 'Lab/Radiology Services',
                    rxValue: controller.diagnosticFacilities,
                    onChanged: (v) => controller.diagnosticFacilities.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.local_pharmacy_outlined,
                    title: 'Pharmacy Availability',
                    subtitle: 'In-house Medical Shop',
                    rxValue: controller.pharmacyAvailability,
                    onChanged: (v) => controller.pharmacyAvailability.value = v,
                  ),
                  const SizedBox(height: 20),

                  // Pro Tip Banner
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline,
                            size: 18, color: Color(0xFF0D9488)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                              children: const [
                                TextSpan(
                                  text: 'PRO TIP\n',
                                  style: TextStyle(
                                    color: Color(0xFF0D9488),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'Verify that your ICU bed count matches the registered capacity with the state health department.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildNextButton(onTap: controller.goToNext),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int step) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: step / 4,
        minHeight: 5,
        backgroundColor: Colors.grey.shade300,
        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontFamily: 'Mulish',
        fontSize: 14,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildServiceToggleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required RxBool rxValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: const Color(0xFF0D9488)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D9488),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
                value: rxValue.value,
                onChanged: onChanged,
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF0D9488),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey.shade300,
              )),
        ],
      ),
    );
  }

  Widget _buildNextButton({required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Next Step',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
