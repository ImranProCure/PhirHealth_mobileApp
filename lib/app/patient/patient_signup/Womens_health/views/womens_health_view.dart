import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/womens_health_controller.dart';

class WomensHealthView extends GetView<WomensHealthController> {
  const WomensHealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'patient_step5_title'.tr,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'patient_step5_heading'.tr,
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
                  value: 5 / 6,
                  minHeight: 8,
                  backgroundColor: Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation(Color(0xFF0D9488)),
                ),
              ),

              const SizedBox(height: 30),

              /// MENSTRUAL
              Text(
                'patient_step5_menstrual'.tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'patient_step5_menstrual_q'.tr,
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              Text(
                'patient_step5_last_period'.tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              _dateInput(
                textController: controller.lastPeriodController,
              ),

              const SizedBox(height: 30),

              /// PREGNANCY STATUS
              Text(
                'patient_step5_pregnancy'.tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'patient_step5_pregnancy_q'.tr,
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              Obx(() => Row(
                    children: [
                      _chip(
                        label: "patient_step5_pregnancy_yes".tr,
                        selected: controller.isPregnant.value,
                        onTap: () => controller.setPregnancy(true),
                      ),
                      const SizedBox(width: 12),
                      _chip(
                        label: "patient_step5_pregnancy_no".tr,
                        selected: !controller.isPregnant.value,
                        onTap: () => controller.setPregnancy(false),
                      ),
                    ],
                  )),

              const SizedBox(height: 20),

              /// DELIVERY DATE (VISIBLE ONLY WHEN YES)

              Obx(() {
                if (!controller.isPregnant.value) {
                  return const SizedBox();
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'patient_step5_delivery_date'.tr,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _dateInput(
                      textController: controller.deliveryDateController,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 30),

              /// HISTORY
              Text(
                'patient_step5_gyno_history'.tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'patient_step5_gyno_history_q'.tr,
                style: TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 20),

              _textArea(
                controller: controller.historyController,
                hint: 'patient_step5_gyno_hint'.tr,
              ),

              const SizedBox(height: 50),

              /// NEXT BUTTON
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
                    onPressed: controller.goToNextStep,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'add_other'.tr,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  /// CHIP
  Widget _chip({
    required String label,
    required bool selected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 18,
              color:
                  selected ? const Color(0xFF0D9488) : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  /// DATE INPUT
  Widget _dateInput({
    required TextEditingController textController,
  }) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.pickDate(Get.context!, textController),
              child: AbsorbPointer(
                child: TextField(
                  controller: textController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'MM/DD/YYYY',
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => controller.pickDate(Get.context!, textController),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFF0D9488),
            ),
          )
        ],
      ),
    );
  }

  /// TEXT AREA
  Widget _textArea({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }
}
