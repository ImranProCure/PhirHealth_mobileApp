import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/inventory_offerings_controller.dart';

class InventoryOfferingsView extends GetView<InventoryOfferingsController> {
  const InventoryOfferingsView({super.key});

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
                      'Inventory & Offerings',
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

                  // Type of Medicines Available
                  const Text(
                    'Type of Medicines Available',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.medicineTypes.map((type) {
                          final selected =
                              controller.selectedMedicineTypes.contains(type);
                          return GestureDetector(
                            onTap: () => controller.toggleMedicineType(type),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF0D9488)
                                      : Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selected
                                          ? const Color(0xFF0D9488)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: selected
                                            ? const Color(0xFF0D9488)
                                            : Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: selected
                                        ? const Icon(Icons.check,
                                            size: 13, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: selected
                                          ? const Color(0xFF0D9488)
                                          : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 24),

                  // Regulatory & Compliance
                  const Text(
                    'Regulatory & Compliance',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  _buildServiceToggleCard(
                    icon: Icons.medical_services_outlined,
                    title: 'Schedule Drugs',
                    subtitle: 'Availability of restricted substances',
                    rxValue: controller.scheduleDrugs,
                    onChanged: (v) => controller.scheduleDrugs.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.local_pharmacy_outlined,
                    title: 'Generic Medicines',
                    subtitle: 'Stocking equivalent low-cost options',
                    rxValue: controller.genericMedicines,
                    onChanged: (v) => controller.genericMedicines.value = v,
                  ),
                  const SizedBox(height: 12),
                  _buildServiceToggleCard(
                    icon: Icons.description_outlined,
                    title: 'E-Prescriptions',
                    subtitle: 'Ability to process digital doctor slips',
                    rxValue: controller.ePrescriptions,
                    onChanged: (v) => controller.ePrescriptions.value = v,
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
                                      'Accepting E-Prescriptions can increase your order volume by up to 24% in the first month.',
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
