import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/reminder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    final context = NotificationService.navigatorKey.currentContext;
    if (context == null) return;
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: (title != null) ? Text(title) : null,
        content: (body != null) ? Text(body) : null,
      ),
    );
  }

  notificationDetails(int icon) async {
    final iconPath = await getImagePath(icon.toString());
    return NotificationDetails(
        android: AndroidNotificationDetails('habits', 'habits remind',
            largeIcon: (iconPath != null)
                ? FilePathAndroidBitmap(
                    iconPath) //DrawableResourceAndroidBitmap
                : null,
            importance: Importance.max),
        iOS: DarwinNotificationDetails(
            attachments: (iconPath != null)
                ? [DarwinNotificationAttachment(iconPath)]
                : null));
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
            title: habit.title, reminder: reminder, icon: habit.icon);
      }
    }
  }

  Future<String?> getImagePath(String icon) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/icon_$icon.png";
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

  Future<void> setImageInAssets(String icon) async {
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/icon_$icon.png";
    final file = File(path);
    if (await file.exists()) {
      return;
    }
    final imageBytes =
        await rootBundle.load('assets/icons/habit_icon ($icon).png');
    final bytes = imageBytes.buffer.asUint8List();
    await file.writeAsBytes(bytes);
    return;
  }

  Future<void> scheduleNotification(
      {required String title,
      String? body,
      required Reminder reminder,
      required int icon}) async {
    setImageInAssets(icon.toString());
    await notificationsPlugin.zonedSchedule(
        reminder.id,
        title,
        body,
        nextInstanceOfTime(reminder.time, reminder.days),
        await notificationDetails(icon),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  tz.TZDateTime _nextInstanceOfHour(tz.TZDateTime time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime nextInstanceOfTime(DateTime time, List<bool> days) {
    tz.TZDateTime scheduledDate =
        _nextInstanceOfHour(tz.TZDateTime.from(time, tz.local));
    while (!days[scheduledDate.weekday % 7]) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
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