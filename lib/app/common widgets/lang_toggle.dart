// lib/app/common/widgets/lang_toggle.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Global observable — poori app mein ek hi state
final RxBool isHindiGlobal = false.obs;

class LangToggle extends StatelessWidget {
  const LangToggle({super.key});

  void _toggle() {
    isHindiGlobal.value = !isHindiGlobal.value;
    if (isHindiGlobal.value) {
      Get.updateLocale(const Locale('hi', 'IN'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isHindi = isHindiGlobal.value; // ✅ actual observable
      return GestureDetector(
        onTap: _toggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          height: 36,
          width: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(
              color: const Color(0xFF0D9488).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment:
                    isHindi ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Text(
                        'E',
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color:
                              isHindi ? const Color(0xFF0D9488) : Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'अ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color:
                              isHindi ? Colors.white : const Color(0xFF0D9488),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
