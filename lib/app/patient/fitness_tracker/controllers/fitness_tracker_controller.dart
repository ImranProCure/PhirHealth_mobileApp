import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

class FitnessTrackerController extends GetxController {
  // ── Observables ──────────────────────────────────────────
  final RxInt steps = 0.obs;
  final RxInt dailyGoal = 5000.obs;
  final RxString status = 'Initializing...'.obs;
  final RxList<Map<String, dynamic>> weekData = <Map<String, dynamic>>[].obs;

  // ── Derived getters ───────────────────────────────────────
  int get goal => dailyGoal.value;
  double get progress => (steps.value / goal).clamp(0.0, 1.0);

  double get distance =>
      double.parse((steps.value * 0.000762).toStringAsFixed(2));

  int get calories => (steps.value * 0.04).round();

  int get totalWeekSteps =>
      weekData.fold(0, (sum, d) => sum + (d['steps'] as int));

  String get date => DateFormat('EEEE, d MMM').format(DateTime.now());
  int get recommendedSteps => 6000;

  String get motivationText {
    final remaining = goal - steps.value;
    if (remaining <= 0) return '🎉 Goal achieved! Amazing work!';
    final minsLeft = (remaining / 100).round();
    return 'Great Job! Only ~$minsLeft mins more to reach your goal.';
  }

  // ── Private ───────────────────────────────────────────────
  Database? _db;
  int _baselineSteps = 0;
  bool _baselineSet = false;
  final String _todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

  // ── Lifecycle ─────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _initDB().then((_) => _load());
  }

  // ── DB Init ───────────────────────────────────────────────
  Future<void> _initDB() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      p.join(dbPath, 'fitness.db'),
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE settings (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE daily_steps (
            date TEXT PRIMARY KEY,
            steps INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // ── Load on every screen entry ────────────────────────────
  Future<void> _load() async {
    await _loadGoal();
    await _loadWeekData();
    await _requestPermissionAndStartPedometer();
  }

  Future<void> _loadGoal() async {
    final rows = await _db!
        .query('settings', where: 'key = ?', whereArgs: ['daily_goal']);
    if (rows.isNotEmpty) {
      dailyGoal.value = int.parse(rows.first['value'] as String);
    }
  }

  Future<void> _loadWeekData() async {
    final today = DateTime.now();
    final List<Map<String, dynamic>> result = [];

    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final key = DateFormat('yyyy-MM-dd').format(day);
      final dayLabel = DateFormat('E').format(day)[0]; // M T W T F S S

      final rows =
          await _db!.query('daily_steps', where: 'date = ?', whereArgs: [key]);
      final int savedSteps = rows.isNotEmpty ? rows.first['steps'] as int : 0;

      // Today's bar will be updated live from pedometer
      final isToday = key == _todayKey;
      final displaySteps = isToday ? steps.value : savedSteps;

      String color;
      if (displaySteps == 0) {
        color = 'gray';
      } else if (displaySteps >= dailyGoal.value) {
        color = 'green';
      } else {
        color = 'orange';
      }

      result.add({
        'day': dayLabel,
        'date': key,
        'steps': displaySteps,
        'color': color,
        'isToday': isToday,
      });
    }

    weekData.assignAll(result);
  }

  // ── Pedometer ─────────────────────────────────────────────
  Future<void> _requestPermissionAndStartPedometer() async {
    final status = await Permission.activityRecognition.request();
    if (status.isGranted) {
      _startPedometer();
    } else {
      this.status.value = 'Permission denied';
    }
  }

  void _startPedometer() {
    Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: (e) => status.value = 'Step count unavailable',
    );
  }

  void _onStepCount(dynamic event) async {
    final sensorTotal = event.steps as int;

    if (!_baselineSet) {
      // Try loading saved baseline for today
      final rows = await _db!.query(
        'settings',
        where: 'key = ?',
        whereArgs: ['baseline_$_todayKey'],
      );
      if (rows.isNotEmpty) {
        _baselineSteps = int.parse(rows.first['value'] as String);
      } else {
        // First reading today — save as baseline
        _baselineSteps = sensorTotal;
        await _db!.insert(
          'settings',
          {'key': 'baseline_$_todayKey', 'value': '$_baselineSteps'},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      _baselineSet = true;
    }

    final todaySteps = (sensorTotal - _baselineSteps).clamp(0, 999999);
    steps.value = todaySteps;
    status.value = 'Live';

    // Persist today's steps
    await _db!.insert(
      'daily_steps',
      {'date': _todayKey, 'steps': todaySteps},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update today's bar in weekData live
    final idx = weekData.indexWhere((d) => d['isToday'] == true);
    if (idx != -1) {
      final updated = Map<String, dynamic>.from(weekData[idx]);
      updated['steps'] = todaySteps;
      updated['color'] = todaySteps == 0
          ? 'gray'
          : todaySteps >= dailyGoal.value
              ? 'green'
              : 'orange';
      weekData[idx] = updated;
    }
  }

  // ── Goal Controls ─────────────────────────────────────────
  void incrementGoal() => dailyGoal.value += 500;
  void decrementGoal() {
    if (dailyGoal.value > 500) dailyGoal.value -= 500;
  }

  Future<void> saveGoal() async {
    await _db!.insert(
      'settings',
      {'key': 'daily_goal', 'value': '${dailyGoal.value}'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // Refresh weekly colors since goal changed
    await _loadWeekData();
    Get.snackbar(
      'Goal Updated',
      'Daily goal set to ${dailyGoal.value} steps',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0D9488),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  void shareOnWhatsApp() {
    // implement share logic
  }

  void openSettings() {
    // implement settings nav
  }
}
