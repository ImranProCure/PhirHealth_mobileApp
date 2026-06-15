import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../app/Doctor/doctor_dashboard/controllers/doctor_dashboard_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/Doctor/doctor_dashboard/controllers/doctor_dashboard_controller.dart';

class MeetingWebViewScreen extends StatefulWidget {
  const MeetingWebViewScreen({super.key});

  @override
  State<MeetingWebViewScreen> createState() => _MeetingWebViewScreenState();
}

class _MeetingWebViewScreenState extends State<MeetingWebViewScreen> {
  final DoctorDashboardController controller = Get.find();
  late WebViewController _webController;

  late final Map<String, dynamic> apt;
  late final String meetLink;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>;
    apt = args;
    meetLink = args['meet_link']?.toString() ?? '';

    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36')
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (request) {
          final url = request.url;
          if (url.startsWith('intent://')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..loadRequest(Uri.parse(meetLink));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),

            // Center text
            const Column(
              children: [
                Icon(Icons.videocam, color: Colors.white54, size: 64),
                SizedBox(height: 16),
                Text(
                  'Meeting is open in browser',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Press End Meeting when done',
                  style: TextStyle(color: Colors.white38, fontSize: 13),
                ),
              ],
            ),

            // End Meeting button
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Obx(() => ElevatedButton.icon(
                    onPressed: controller.isEndingMeeting.value
                        ? null
                        : () => controller.endMeeting(apt),
                    icon: const Icon(Icons.call_end, color: Colors.white),
                    label: Text(
                      controller.isEndingMeeting.value
                          ? 'Ending...'
                          : 'End Meeting',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: const StadiumBorder(),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
