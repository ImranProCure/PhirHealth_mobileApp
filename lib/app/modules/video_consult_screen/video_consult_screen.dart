// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VideoConsultScreen extends StatefulWidget {
//   final String url;
//   final String doctorName;

//   const VideoConsultScreen({
//     super.key,
//     required this.url,
//     this.doctorName = 'Doctor',
//   });

//   @override
//   State<VideoConsultScreen> createState() => _VideoConsultScreenState();
// }

// class _VideoConsultScreenState extends State<VideoConsultScreen> {
//   late final WebViewController _controller;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();

//     // Google Meet dynamic link se direct URL nikalo
//     String finalUrl = widget.url;
//     if (widget.url.contains('meet.app.goo.gl') ||
//         widget.url.contains('meet.google.com')) {
//       // Direct meet URL use karo
//       final uri = Uri.parse(widget.url);
//       final link = uri.queryParameters['link'] ?? '';
//       if (link.isNotEmpty) {
//         finalUrl = link; // https://meet.google.com/sud-zhvw-vwj
//       }
//     }

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.black)
//       ..setUserAgent(
//           // Desktop user agent - Meet mobile pe theek kaam nahi karta WebView mein
//           'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onPageStarted: (url) => setState(() => isLoading = true),
//           onPageFinished: (url) => setState(() => isLoading = false),
//           onNavigationRequest: (NavigationRequest request) async {
//             final url = request.url;
//             if (url.startsWith('http://') || url.startsWith('https://')) {
//               return NavigationDecision.navigate;
//             }
//             final uri = Uri.tryParse(url);
//             if (uri != null && await canLaunchUrl(uri)) {
//               await launchUrl(uri, mode: LaunchMode.externalApplication);
//             }
//             return NavigationDecision.prevent;
//           },
//           onWebResourceError: (error) {
//             debugPrint('WebView Error: ${error.description}');
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse(finalUrl));
//   } // ← initState band yahan hota hai - tumhari file mein yeh MISSING tha

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dr. ${widget.doctorName}'),
//         backgroundColor: Colors.teal,
//         foregroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () => _controller.reload(),
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           WebViewWidget(controller: _controller),
//           if (isLoading)
//             const Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: Colors.teal),
//                   SizedBox(height: 16),
//                   Text('Connecting to doctor...'),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
