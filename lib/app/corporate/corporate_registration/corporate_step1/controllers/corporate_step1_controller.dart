import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CorporateStep1Controller extends GetxController {
  // Company Details
  final companyNameController = TextEditingController();
  final locationsController = TextEditingController();

  final RxString selectedIndustry = ''.obs;
  final RxString selectedCompanySize = ''.obs;

  final List<String> industryOptions = [
    'Healthcare',
    'Technology',
    'Finance',
    'Education',
    'Manufacturing',
    'Retail',
    'Others',
  ];

  final List<String> companySizeOptions = [
    '1-50',
    '51-200',
    '201-500',
    '501-1000',
    '1000+',
  ];

  // POC
  final primaryContactController = TextEditingController();
  final designationController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();

  // Avatar
  final RxString avatarPath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAvatar() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file != null) {
      avatarPath.value = file.path;
    }
  }

  void showIndustrySheet(BuildContext context) {
    _showOptionsSheet(
      context: context,
      title: 'Select Industry / Sector',
      options: industryOptions,
      onSelect: (val) => selectedIndustry.value = val,
    );
  }

  void showCompanySizeSheet(BuildContext context) {
    _showOptionsSheet(
      context: context,
      title: 'Number of Employees',
      options: companySizeOptions,
      onSelect: (val) => selectedCompanySize.value = val,
    );
  }

  void _showOptionsSheet({
    required BuildContext context,
    required String title,
    required List<String> options,
    required ValueChanged<String> onSelect,
  }) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (_) => SafeArea(
                child: SingleChildScrollView(
              child: Padding(
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
                            style: const TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 14,
                            ),
                          ),
                          onTap: () {
                            onSelect(opt);
                            Get.back();
                          },
                        )),
                  ],
                ),
              ),
            )));
  }

  void goToNext() {
    Get.toNamed('/corporate-step2');
  }

  @override
  void onClose() {
    companyNameController.dispose();
    locationsController.dispose();
    primaryContactController.dispose();
    designationController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.onClose();
  }
}
