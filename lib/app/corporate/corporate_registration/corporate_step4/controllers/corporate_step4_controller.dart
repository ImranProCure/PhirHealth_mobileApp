import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CorporateStep4Controller extends GetxController {
  // Decision Making
  final RxString selectedApprover = ''.obs;
  final RxString selectedApprovalProcess = 'Immediate'.obs;

  final List<String> approverOptions = [
    'Jane Doe, Procurement Lead',
    'John Smith, HR Manager',
    'Alice Brown, Finance Head',
    'Others',
  ];

  final List<String> approvalProcessOptions = [
    'Immediate',
    'Within 24 hours',
    'Within 3 days',
    'Within a week',
    'Board approval required',
  ];

  // Commercial Expectations
  final RxString selectedPricingModel = 'Fixed Price'.obs;
  final RxString selectedContractDuration = ''.obs;

  final List<String> pricingModelOptions = [
    'Fixed Price',
    'Per Employee',
    'Subscription',
    'Milestone Based',
    'Custom',
  ];

  final List<String> contractDurationOptions = [
    '3 months',
    '6 months',
    '12 months',
    '18 months',
    '24 months',
    'Custom',
  ];

  // Compliance & Extras
  final legalController = TextEditingController();
  final additionalInfoController = TextEditingController();

  void showBottomSheet(
    BuildContext context, {
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...options.map((opt) => ListTile(
                  title: Text(
                    opt,
                    style: const TextStyle(fontFamily: 'Mulish', fontSize: 14),
                  ),
                  onTap: () {
                    onSelect(opt);
                    Get.back();
                  },
                )),
          ],
        ),
      ),
    );
  }

  void submitEnquiry() {
    // TODO: API call
    // Get.offAllNamed('/select-facility-type');
  }

  @override
  void onClose() {
    legalController.dispose();
    additionalInfoController.dispose();
    super.onClose();
  }
}
