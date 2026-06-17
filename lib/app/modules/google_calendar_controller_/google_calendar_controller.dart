import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_links/app_links.dart';
import '../../service/api/common_api/google_calendar_api/google_calendar_api.dart';

class GoogleCalendarController extends GetxController
    with WidgetsBindingObserver {
  final _api = GoogleCalendarApi();
  final _appLinks = AppLinks();
  StreamSubscription? _linkSubscription; // ✅ add karo

  var isLoading = false.obs;
  var isConnected = false.obs;
  bool _awaitingReturn = false;
  bool _deepLinkHandled = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _listenDeepLink();
  }

  void _listenDeepLink() {
    // ✅ Pehle cancel karo agar pehle se chal raha hai
    _linkSubscription?.cancel();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (_deepLinkHandled) return;
      _deepLinkHandled = true;

      print('DEEP LINK => $uri');
      if (uri.host == 'calendar-callback') {
        _checkStatus();
      }

      Future.delayed(const Duration(seconds: 5), () {
        _deepLinkHandled = false;
      });
    });
  }

  @override
  void onClose() {
    _linkSubscription?.cancel(); // ✅ dispose karo
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _awaitingReturn) {
      _awaitingReturn = false;
      _checkStatus();
    }
  }

  Future<void> connectCalendar() async {
    try {
      isLoading.value = true;

      final res = await _api.connectGoogleCalendar();

      if (!res.status) {
        Get.snackbar('Error', res.message);
        return;
      }

      final msg = res.data['message'] as Map<String, dynamic>;

      if (msg['already_connected'] == true) {
        isConnected.value = true;
        Get.snackbar('Calendar', 'Already connected!');
        return;
      }

      final authUrl = msg['auth_url'] as String?;
      if (authUrl == null || authUrl.isEmpty) {
        Get.snackbar('Error', 'Invalid auth URL');
        return;
      }

      final uri = Uri.parse(authUrl);
      _awaitingReturn = true;
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      _awaitingReturn = false;
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkStatus() async {
    try {
      final res = await _api.connectGoogleCalendar();
      if (!res.status) return;

      final msg = res.data['message'] as Map<String, dynamic>;
      isConnected.value = msg['already_connected'] == true;

      if (isConnected.value) {
        Get.snackbar(
          '✅ Success',
          'Google Calendar connected!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {}
  }
}
