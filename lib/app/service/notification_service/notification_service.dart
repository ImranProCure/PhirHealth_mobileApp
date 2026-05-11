import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  if (response.actionId == 'snooze_action') {
    // ✅ Background mein fresh initialize karo
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    final plugin = FlutterLocalNotificationsPlugin();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await plugin.initialize(settings);

    await plugin.cancel(response.id ?? 0);

    final snoozeTime =
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10));

    final androidDetails = AndroidNotificationDetails(
      'medicine_reminder_v2',
      'Medicine Reminders',
      channelDescription: 'Reminds you to take your medicine',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      timeoutAfter: 60000 * 5,
      actions: [
        AndroidNotificationAction(
          'take_action',
          'Take ✅',
          cancelNotification: true,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze_action',
          'Snooze 🔔',
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
    );

    await plugin.zonedSchedule(
      (response.id ?? 0) + 10000,
      '⏰ Snoozed Reminder',
      'Time to take your medicine',
      snoozeTime,
      NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.actionId == 'snooze_action') {
      snooze(
        id: response.id ?? 0,
        medicineName: 'Medicine',
        foodInstruction: 'as prescribed',
      );
    }
  }

  static const DarwinNotificationDetails _iosDetails =
      DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  Future<void> scheduleDailyNotification({
    required int id,
    required String medicineName,
    required String foodInstruction,
    required int hour,
    required int minute,
    required String type,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'medicine_reminder_v2',
      'Medicine Reminders',
      channelDescription: 'Reminds you to take your medicine',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      timeoutAfter: 60000 * 5,
      actions: [
        AndroidNotificationAction(
          'take_action',
          'Take ✅',
          cancelNotification: true,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze_action',
          'Snooze 🔔',
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
      styleInformation: BigTextStyleInformation(
        'Time to take $medicineName — $foodInstruction',
        summaryText: 'Medicine Reminder',
      ),
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: _iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    print('📅 Scheduling: $medicineName at $hour:$minute → $scheduledTime');

    await _plugin.zonedSchedule(
      id,
      '💊 Medicine Reminder',
      'Take $medicineName — $foodInstruction',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleForDays({
    required int id,
    required String medicineName,
    required String foodInstruction,
    required int hour,
    required int minute,
    required List<int> days,
  }) async {
    for (final day in days) {
      await _scheduleWeekly(
        id: id + day,
        medicineName: medicineName,
        foodInstruction: foodInstruction,
        hour: hour,
        minute: minute,
        day: day,
      );
    }
  }

  Future<void> _scheduleWeekly({
    required int id,
    required String medicineName,
    required String foodInstruction,
    required int hour,
    required int minute,
    required int day,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'medicine_reminder_v2',
      'Medicine Reminders',
      channelDescription: 'Reminds you to take your medicine',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      timeoutAfter: 60000 * 5,
      actions: [
        AndroidNotificationAction(
          'take_action',
          'Take ✅',
          cancelNotification: true,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze_action',
          'Snooze 🔔',
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: _iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledTime =
        _nextInstanceOfWeekday(now, day, hour, minute);

    await _plugin.zonedSchedule(
      id,
      '💊 Medicine Reminder',
      'Take $medicineName — $foodInstruction',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _nextInstanceOfWeekday(
      tz.TZDateTime from, int weekday, int hour, int minute) {
    tz.TZDateTime candidate =
        tz.TZDateTime(tz.local, from.year, from.month, from.day, hour, minute);
    while (candidate.weekday != weekday || candidate.isBefore(from)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  Future<void> snooze({
    required int id,
    required String medicineName,
    required String foodInstruction,
  }) async {
    await cancelNotification(id);

    final androidDetails = AndroidNotificationDetails(
      'medicine_reminder_v2',
      'Medicine Reminders',
      channelDescription: 'Reminds you to take your medicine',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      enableVibration: true,
      timeoutAfter: 60000 * 5,
      actions: [
        AndroidNotificationAction(
          'take_action',
          'Take ✅',
          cancelNotification: true,
          showsUserInterface: true,
        ),
        AndroidNotificationAction(
          'snooze_action',
          'Snooze 🔔',
          cancelNotification: true,
          showsUserInterface: true,
        ),
      ],
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: _iosDetails,
    );

    final snoozeTime =
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 10));

    await _plugin.zonedSchedule(
      id + 10000,
      '⏰ Snoozed Reminder',
      'Take $medicineName — $foodInstruction',
      snoozeTime,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // ✅
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
