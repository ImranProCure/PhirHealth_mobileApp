import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<PrivacyPolicyScreen> {
  late Stream<StepCount> _stepCountStream;
  String _steps = '0';
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInit();
  }

  Future<void> _requestPermissionAndInit() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      _initPedometer();
    } else {
      setState(() {
        _status = 'Permission denied';
      });
    }
  }

  void _initPedometer() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(
      (event) {
        setState(() {
          _steps = event.steps.toString();
          _status = 'Counting';
        });
      },
      onError: (error) {
        setState(() {
          _status = 'Step Count not available';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Steps', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Steps Taken', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 16),
            Text(
              _steps,
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text('Status: $_status',
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
