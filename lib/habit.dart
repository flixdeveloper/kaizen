import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/heat_object.dart';
import 'package:kaizen/reminder.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/settings_screen.dart';

part 'habit.g.dart';

@JsonSerializable(explicitToJson: true)
class Habit {
  int? id = UniqueKey().hashCode;
  String title;
  String? description;
  int icon;
  bool isBuild;
  String frequency;
  List<bool> customDays;
  int goal;
  int did = 0;
  bool allowReminder = false;
  List<Reminder> reminders = [];
  late DateTime resetAt;

  Habit(this.title, this.description, this.icon, this.isBuild, this.frequency,
      this.customDays, this.goal, this.allowReminder, this.reminders) {
    this.frequency = freqToNum(this.frequency);
  }

  Habit.fromHabit(
    this.customDays, {
    this.title = '',
    this.description = '',
    this.icon = 0,
    this.isBuild = true,
    this.frequency = '',
    this.goal = 0,
  }) {}

  List<Reminder> copyReminders() {
    final List<Reminder> copy = [];
    for (Reminder reminder in reminders) {
      copy.add(Reminder.copyOf(reminder));
    }
    return copy;
  }

  int getId() {
    if (id != null) return id!;
    id = UniqueKey().hashCode;
    return id!;
  }

  String freqToNum(String freq) {
    int? num = int.tryParse(freq);
    if (num != null) return num.toString();
    switch (freq) {
      case 'Daily':
        return '0';
      case 'Weekly':
        return '1';
      default:
        return '2';
    }
  }

  didPlus(BuildContext context) {
    did++;
    Heat.habitDidPlus(this, context);
    saveHabit(habits);
  }

  void resetHabit(BuildContext context) {
    DateTime now = DateTime.now();
    final newReset = nextReset(context);
    if (now.isAfter(resetAt)) {
      did = 0;
      resetAt = newReset;
    } else if (newReset.isBefore(resetAt)) {
      resetAt = newReset;
    }
  }

  void setNextReset(BuildContext context) {
    resetAt = nextReset(context);
  }

  DateTime nextReset(BuildContext context, {DateTime? nextFor}) {
    DateTime d = DateTime.now();
    DateTime now = nextFor ?? DateTime(d.year, d.month, d.day);
    switch (frequency) {
      case "0":
        {
          return now.add(const Duration(days: 1));
        }
      case "1":
        {
          var firstDayTZ = int.parse(SettingsScreen.firstDay);
          var nowWeekDay = now.weekday % 7;
          int diff = nowWeekDay - firstDayTZ;
          if (diff < 0) diff += 7;

          DateTime firstDayOfNextweek = now.add(Duration(days: 7 - diff));
          return firstDayOfNextweek;
        }
      default:
        {
          return DateTime(now.year, now.month + 1, 1);
        }
    }
  }

  DateTime lastReset(BuildContext context, {DateTime? lastFor}) {
    DateTime d = DateTime.now();
    DateTime now = lastFor ?? DateTime(d.year, d.month, d.day);
    switch (frequency) {
      case "0":
        {
          return now;
        }
      case "1":
        {
          var firstDayTZ = int.parse(SettingsScreen.firstDay);
          var nowWeekDay = now.weekday % 7;
          int diff = nowWeekDay - firstDayTZ;
          if (diff < 0) diff += 7;

          DateTime firstDayOfNextweek = now.subtract(Duration(days: diff));
          return firstDayOfNextweek;
        }
      default:
        {
          return DateTime(now.year, now.month, 1);
        }
    }
  }

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
