import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/reminder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  notificationDetails(int icon) async {
    return NotificationDetails(
        android: AndroidNotificationDetails('habits', 'habits remind',
            largeIcon: DrawableResourceAndroidBitmap('habit_icon_$icon'),
            importance: Importance.max),
        iOS: DarwinNotificationDetails(attachments: [
          DarwinNotificationAttachment(
              await getImageFromAssets(icon.toString()))
        ]));
  }

  void cancelSchedule(Habit habit) {
    for (Reminder reminder in habit.reminders) {
      notificationsPlugin.cancel(reminder.id);
    }
  }

  void setNotifications(Habit habit) {
    if (habit.allowReminder) {
      for (var reminder in habit.reminders) {
        scheduleNotification(
            title: habit.title, body: '', reminder: reminder, icon: habit.icon);
      }
    }
  }

  Future<String> getImageFromAssets(String icon) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/icon_$icon";
    final file = File(path);
    if (await file.exists()) {
      return path;
    }
    final imageBytes =
        await rootBundle.load('assets/icons/habit_icon ($icon).png');
    final bytes = imageBytes.buffer.asUint8List();
    await file.writeAsBytes(bytes);
    return path;
  }

  //Future showNotification(
  //    {int? id,
  //    String? title,
  //    String? body,
  //    String? payLoad,
  //    required int icon}) async {
  //  id ??= UniqueKey().hashCode;
  //  return notificationsPlugin.show(
  //      id, title, body, await notificationDetails(icon),
  //      payload: payLoad);
  //}

  Future<void> scheduleNotification(
      {required String title,
      required String body,
      required Reminder reminder,
      required int icon}) async {
    for (int index = 0; index < reminder.days.length; index++) {
      if (!reminder.days[index]) {
        continue;
      }
      await notificationsPlugin.zonedSchedule(
          reminder.id,
          title,
          body,
          nextInstanceOfTime(reminder.time, index),
          await notificationDetails(icon),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
    }
  }

  tz.TZDateTime _nextInstanceOfHour(DateTime time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime nextInstanceOfTime(DateTime time, int day) {
    tz.TZDateTime scheduledDate = _nextInstanceOfHour(time);
    while (scheduledDate.weekday % 7 != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
