import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/add_medicine_controller.dart';

class AddMedicineView extends GetView<AddMedicineController> {
  const AddMedicineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text('Add  Medicine',
            style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== MEDICINE NAME =====
                  const Text('Medicine Name',
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: TextField(
                      controller: controller.nameController,
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          color: Colors.black),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search,
                            color: Color(0xFF9CA3AF), size: 20),
                        hintText: 'Dolo 650',
                        hintStyle: const TextStyle(
                            fontFamily: 'Mulish', color: Color(0xFF9CA3AF)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== TYPE GRID =====
                  Obx(() => GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.3,
                        children: controller.types.map((t) {
                          final bool isSelected =
                              controller.selectedType.value == t['label'];
                          return GestureDetector(
                            onTap: () =>
                                controller.selectType(t['label'] as String),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF0D9488)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2))
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          t['imagePath'] as String,
                                          width: 60,
                                          height: 60,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.medication,
                                                  size: 50,
                                                  color: Color(0xFF0D9488)),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(t['label'] as String,
                                            style: TextStyle(
                                              fontFamily: 'Mulish',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? const Color(0xFF0D9488)
                                                  : Colors.black,
                                            )),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: isSelected
                                        ? Container(
                                            width: 22,
                                            height: 22,
                                            decoration: const BoxDecoration(
                                                color: Color(0xFF0D9488),
                                                shape: BoxShape.circle),
                                            child: const Icon(Icons.check,
                                                color: Colors.white, size: 14),
                                          )
                                        : Container(
                                            width: 22,
                                            height: 22,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFD1D5DB),
                                                  width: 1.5),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 20),

                  // ===== STRENGTH + UNIT =====
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Strength',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Obx(() => _dropdown(
                                  value: controller.strength.value,
                                  items: controller.strengths,
                                  onChanged: controller.selectStrength,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Unit',
                                style: TextStyle(
                                    fontFamily: 'Mulish',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            Obx(() => _dropdown(
                                  value: controller.unit.value,
                                  items: controller.units,
                                  onChanged: controller.selectUnit,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ===== EMR TOGGLE =====
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Familiar with EMR Systems?',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(height: 2),
                              Text('Alert when 2 pills left',
                                  style: TextStyle(
                                      fontFamily: 'Mulish',
                                      fontSize: 12,
                                      color: Color(0xFF9CA3AF))),
                            ],
                          ),
                        ),
                        Obx(() => Switch(
                              value: controller.emrAlert.value,
                              onChanged: controller.toggleEmr,
                              activeColor: const Color(0xFF0D9488),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // ===== NEXT STEP BUTTON =====
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                      colors: [Color(0xFF00897B), Color(0xFF1565C0)]),
                ),
                child: ElevatedButton(
                  onPressed: controller.nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
      {required String value,
      required List<String> items,
      required Function(String) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
          style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}
