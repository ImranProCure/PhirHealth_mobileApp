import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coach_step1_controller.dart';

class CoachStep1View extends GetView<CoachStep1Controller> {
  const CoachStep1View({super.key});

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
        title: const Text('Step 1 of 6',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
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
                    child: Text('Professional Profile',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.black)),
                  ),
                  const SizedBox(height: 8),
                  _progressBar(1),
                  const SizedBox(height: 24),

                  // ── Avatar with white ring ──
                  Center(
                    child: GestureDetector(
                      onTap: controller.pickAvatar,
                      child: Obx(() {
                        final path = controller.avatarPath.value;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey.shade200, width: 2),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFE8F5F4)),
                                  child: path.isEmpty
                                      ? const Icon(Icons.person_outline,
                                          size: 44, color: Colors.black54)
                                      : ClipOval(
                                          child: Image.file(File(path),
                                              fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF0D9488),
                                    border: Border.all(
                                        color: Colors.white, width: 2)),
                                child: const Icon(Icons.camera_alt,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                      child: Text('Upload Professional Headshot',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Colors.black))),
                  const SizedBox(height: 4),
                  Center(
                      child: Text('Add photo to help clients connect with you.',
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 13,
                              color: Colors.grey.shade500))),
                  const SizedBox(height: 20),

                  _label('Full Name'),
                  const SizedBox(height: 8),
                  _field(
                      controller: controller.fullNameController,
                      hint: 'Enter your name'),
                  const SizedBox(height: 20),

                  // ── Professional Title dropdown ──
                  _label('Professional Title'),
                  const SizedBox(height: 8),
                  Obx(() => _dropdownTile(
                        value: controller.selectedTitle.value.isEmpty
                            ? 'Select your professional title'
                            : controller.selectedTitle.value,
                        isEmpty: controller.selectedTitle.value.isEmpty,
                        onTap: () => _titleSheet(context),
                      )),
                  const SizedBox(height: 20),

                  _label('Short Bio'),
                  const SizedBox(height: 8),
                  _multiField(
                      controller: controller.bioController,
                      hint:
                          'Tell potential clients about your approach and expertise...',
                      minLines: 4),
                  const SizedBox(height: 28),

                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  const SizedBox(height: 20),

                  const Text('Demographics & Location',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 16),

                  const Text('Languages Spoken',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.black)),
                  const SizedBox(height: 10),

                  // ── Language chips — compact so 3 fit one line ──
                  Obx(() => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...controller.allLanguages.map((lang) {
                            final sel =
                                controller.selectedLanguages.contains(lang);
                            return GestureDetector(
                              onTap: () => controller.toggleLanguage(lang),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(
                                    color: sel
                                        ? const Color(0xFF0D9488)
                                        : Colors.grey.shade300,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: sel
                                            ? const Color(0xFF0D9488)
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: sel
                                              ? const Color(0xFF0D9488)
                                              : Colors.grey.shade400,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: sel
                                          ? const Icon(Icons.check,
                                              size: 11, color: Colors.white)
                                          : null,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(lang,
                                        style: TextStyle(
                                            fontFamily: 'Mulish',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: sel
                                                ? const Color(0xFF0D9488)
                                                : Colors.black87)),
                                  ],
                                ),
                              ),
                            );
                          }),
                          GestureDetector(
                            onTap: () => _addLangDialog(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: const Color(0xFF0D9488), width: 1.5),
                              ),
                              child: const Text('+ Add',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF0D9488))),
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(height: 20),

                  _label('City'),
                  const SizedBox(height: 8),
                  _field(
                      controller: controller.cityController,
                      hint: 'e.g. San Francisco'),
                  const SizedBox(height: 16),

                  Row(children: [
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _label('State'),
                          const SizedBox(height: 8),
                          _field(
                              controller: controller.stateController,
                              hint: 'State'),
                        ])),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          _label('Country'),
                          const SizedBox(height: 8),
                          _field(
                              controller: controller.countryController,
                              hint: 'Country'),
                        ])),
                  ]),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          _nextBtn(),
        ],
      ),
    );
  }

  // ── Sheet in VIEW using StatefulBuilder — no Obx inside builder ──
  void _titleSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) => StatefulBuilder(
        builder: (_, setState) => Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 16),
              const Text('Select Professional Title',
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ...controller.titleOptions.map((opt) {
                final isSel = controller.selectedTitle.value == opt;
                return ListTile(
                  title: Text(opt,
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                          color: isSel
                              ? const Color(0xFF0D9488)
                              : Colors.black87)),
                  trailing: isSel
                      ? const Icon(Icons.check,
                          color: Color(0xFF0D9488), size: 20)
                      : null,
                  onTap: () {
                    // Update Rx value
                    controller.selectedTitle.value = opt;
                    // Trigger local rebuild for checkmark
                    setState(() {});
                    Navigator.pop(sheetCtx);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _addLangDialog(BuildContext context) {
    final tc = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Language',
            style:
                TextStyle(fontFamily: 'Mulish', fontWeight: FontWeight.w700)),
        content: TextField(
            controller: tc,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g. German')),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              controller.addLanguage(tc.text);
              Navigator.pop(ctx);
            },
            child:
                const Text('Add', style: TextStyle(color: Color(0xFF0D9488))),
          ),
        ],
      ),
    );
  }

  // ── Shared widgets ──

  Widget _progressBar(int step) => ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: step / 6,
          minHeight: 5,
          backgroundColor: Colors.grey.shade300,
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0D9488)),
        ),
      );

  Widget _label(String t) => Text(t,
      style: const TextStyle(
          fontFamily: 'Mulish',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87));

  Widget _dropdownTile(
      {required String value,
      required bool isEmpty,
      required VoidCallback onTap}) {
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
        child: Row(children: [
          Expanded(
              child: Text(value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 14,
                      color: isEmpty ? Colors.grey.shade400 : Colors.black87))),
          const SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade500),
        ]),
      ),
    );
  }

  Widget _field(
      {required TextEditingController controller,
      required String hint,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
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
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
      ),
    );
  }

  Widget _multiField(
      {required TextEditingController controller,
      required String hint,
      int minLines = 3}) {
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
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5)),
      ),
    );
  }

  Widget _nextBtn() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: GestureDetector(
          onTap: controller.goToNext,
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
                Text('Next Step',
                    style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      );
}
