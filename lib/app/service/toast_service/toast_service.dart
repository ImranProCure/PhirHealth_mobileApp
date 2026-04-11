import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/service/toast_service/custom_toast.dart';

class ToastService {
  ToastService._();
  static final ToastService instance = ToastService._();

  OverlayEntry? _overlayEntry;
  Timer? _timer;

  void showSuccess(String message, {BuildContext? context}) {
    _showToast(
      message: message,
      backgroundColor: Colors.green,
      context: context,
    );
  }

  void showError(String message, {BuildContext? context}) {
    _showToast(message: message, backgroundColor: Colors.red, context: context);
  }

  void showNormal(
    String message, {
    Color? backgroundColor,
    BuildContext? context,
  }) {
    _showToast(
      message: message,
      backgroundColor: backgroundColor ?? Colors.grey,
      context: context,
    );
  }

  void _showToast({
    required String message,
    required Color backgroundColor,
    BuildContext? context,
  }) {
    // Hide previous toast if any
    _hideToast();

    // Get the overlay context - prioritize passed context, then GetX context
    BuildContext? overlayContext = context ?? Get.context;

    if (overlayContext == null) {
      return;
    }

    // Try to get overlay, with fallback
    OverlayState? overlay;
    try {
      overlay = Overlay.of(overlayContext, rootOverlay: false);
    } catch (e) {
      // If overlay not found, try getting it from navigator or root overlay
      try {
        overlay = Overlay.of(overlayContext, rootOverlay: true);
      } catch (e2) {
        // If still not found, try getting it from navigator directly
        final navigator = Navigator.maybeOf(overlayContext);
        if (navigator != null) {
          overlay = navigator.overlay;
        }
      }
    }

    if (overlay == null) {
      return;
    }
    _overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, -20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: CustomToast(
                    message: message,
                    backgroundColor: backgroundColor,
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(_overlayEntry!);

    _timer = Timer(const Duration(seconds: 3), () {
      _hideToast();
    });
  }

  void _hideToast() {
    _timer?.cancel();
    _timer = null;

    if (_overlayEntry != null) {
      final entry = _overlayEntry!;
      _overlayEntry = null;

      // Animate out
      Future.delayed(const Duration(milliseconds: 300), () {
        entry.remove();
      });
    }
  }
}
