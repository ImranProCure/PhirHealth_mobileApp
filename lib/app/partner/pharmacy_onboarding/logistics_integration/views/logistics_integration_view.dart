import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/logistics_integration_controller.dart';

class LogisticsIntegrationView extends GetView<LogisticsIntegrationController> {
  const LogisticsIntegrationView({super.key});

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
          'Step 3 of 4',
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
                      'Logistics & Integration',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(3),
                  const SizedBox(height: 24),

                  // Home Delivery toggle card
                  _buildServiceToggleCard(
                    icon: Icons.delivery_dining_outlined,
                    title: 'Home Delivery Available',
                    subtitle: 'Do you currently offer doorstep prescription',
                    rxValue: controller.homeDelivery,
                    onChanged: (v) => controller.homeDelivery.value = v,
                  ),
                  const SizedBox(height: 24),

                  // Diet preference (Delivery Time)
                  const Text(
                    'Diet preference',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 14),

                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.selectDeliveryTime('2hours'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                  color:
                                      controller.selectedDeliveryTime.value ==
                                              '2hours'
                                          ? const Color(0xFFE8F5F4)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        controller.selectedDeliveryTime.value ==
                                                '2hours'
                                            ? const Color(0xFF0D9488)
                                            : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 30,
                                      color: controller
                                                  .selectedDeliveryTime.value ==
                                              '2hours'
                                          ? const Color(0xFF0D9488)
                                          : Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '2 Hours',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: controller.selectedDeliveryTime
                                                    .value ==
                                                '2hours'
                                            ? const Color(0xFF0D9488)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () =>
                                  controller.selectDeliveryTime('sameday'),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                decoration: BoxDecoration(
                                  color:
                                      controller.selectedDeliveryTime.value ==
                                              'sameday'
                                          ? const Color(0xFFE8F5F4)
                                          : Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color:
                                        controller.selectedDeliveryTime.value ==
                                                'sameday'
                                            ? const Color(0xFF0D9488)
                                            : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 30,
                                      color: controller
                                                  .selectedDeliveryTime.value ==
                                              'sameday'
                                          ? const Color(0xFF0D9488)
                                          : Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Same Day',
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: controller.selectedDeliveryTime
                                                    .value ==
                                                'sameday'
                                            ? const Color(0xFF0D9488)
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 16),

                  // Custom Time field
                  const Text(
                    'Custom Time',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller.customTimeController,
                    onTap: () => controller.selectDeliveryTime('custom'),
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 24-48 hours',
                      hintStyle: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        color: Colors.grey.shade400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
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
                        borderSide: const BorderSide(
                            color: Color(0xFF0D9488), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Online Order Management System
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Online Order Management\nSystem Avilable?',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0D9488),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Integration with our API requires and active OMS.',
                                style: TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Obx(() => Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        controller.omsAvailable.value = true,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: controller.omsAvailable.value
                                            ? const Color(0xFF0D9488)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'Yes',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: controller.omsAvailable.value
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        controller.omsAvailable.value = false,
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: !controller.omsAvailable.value
                                            ? const Color(0xFF0D9488)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        'No',
                                        style: TextStyle(
                                          fontFamily: 'Mulish',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: !controller.omsAvailable.value
                                              ? Colors.white
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
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
