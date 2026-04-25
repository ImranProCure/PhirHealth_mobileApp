import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/corporate_step4_controller.dart';

class CorporateStep4View extends GetView<CorporateStep4Controller> {
  const CorporateStep4View({super.key});

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
          'Step 4 of 4',
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
                      'Final Details',
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildProgressBar(4),
                  const SizedBox(height: 24),

                  // ── Decision Making ──
                  const Text(
                    'Decision Making',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Approver Name & Role'),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdownTile(
                        value: controller.selectedApprover.value.isEmpty
                            ? 'e.g. Jane Doe, Procurement Lead'
                            : controller.selectedApprover.value,
                        isEmpty: controller.selectedApprover.value.isEmpty,
                        onTap: () => controller.showBottomSheet(
                          context,
                          title: 'Approver Name & Role',
                          options: controller.approverOptions,
                          onSelect: (v) =>
                              controller.selectedApprover.value = v,
                        ),
                      )),
                  const SizedBox(height: 20),

                  _buildLabel('Approval Process'),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdownTile(
                        value: controller.selectedApprovalProcess.value,
                        isEmpty: false,
                        onTap: () => controller.showBottomSheet(
                          context,
                          title: 'Approval Process',
                          options: controller.approvalProcessOptions,
                          onSelect: (v) =>
                              controller.selectedApprovalProcess.value = v,
                        ),
                      )),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // ── Commercial Expectations ──
                  const Text(
                    'Commercial Expectations',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Pricing Model'),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdownTile(
                        value: controller.selectedPricingModel.value,
                        isEmpty: false,
                        onTap: () => controller.showBottomSheet(
                          context,
                          title: 'Pricing Model',
                          options: controller.pricingModelOptions,
                          onSelect: (v) =>
                              controller.selectedPricingModel.value = v,
                        ),
                      )),
                  const SizedBox(height: 20),

                  _buildLabel('Contract Duration'),
                  const SizedBox(height: 8),
                  Obx(() => _buildDropdownTile(
                        value: controller.selectedContractDuration.value.isEmpty
                            ? 'e.g. 12 months'
                            : controller.selectedContractDuration.value,
                        isEmpty:
                            controller.selectedContractDuration.value.isEmpty,
                        onTap: () => controller.showBottomSheet(
                          context,
                          title: 'Contract Duration',
                          options: controller.contractDurationOptions,
                          onSelect: (v) =>
                              controller.selectedContractDuration.value = v,
                        ),
                      )),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 24),

                  // ── Compliance & Extras ──
                  const Text(
                    'Compliance & Extras',
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Legal/Data Privacy Requirments'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: controller.legalController,
                    hint: 'e.g. GDPR, local data residency',
                  ),
                  const SizedBox(height: 20),

                  _buildLabel('Additional Info'),
                  const SizedBox(height: 8),
                  _buildMultilineField(
                    controller: controller.additionalInfoController,
                    hint:
                        'Any other specific requirements or details for the PHIR Group team...',
                    minLines: 4,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _buildSubmitButton(onTap: controller.submitEnquiry),
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

  Widget _buildDropdownTile({
    required String value,
    required bool isEmpty,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  color: isEmpty ? Colors.grey.shade400 : Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
          fontFamily: 'Mulish', fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Colors.grey.shade400),
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

  Widget _buildMultilineField({
    required TextEditingController controller,
    required String hint,
    int minLines = 3,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: null,
      style: const TextStyle(
          fontFamily: 'Mulish', fontSize: 14, color: Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            fontFamily: 'Mulish', fontSize: 14, color: Colors.grey.shade400),
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

  Widget _buildSubmitButton({required VoidCallback onTap}) {
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
                'Submit Corporate Enquiry',
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.lock_outline, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
