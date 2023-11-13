import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/reminder.dart';

part 'habit.g.dart';

@JsonSerializable(explicitToJson: true)
class Habit {
  String title;
  int icon;
  bool isBuild;
  String frequency;
  List<bool> customDays;
  int goal;
  int did = 0;
  bool allowReminder = false;
  List<Reminder> reminders = [];
  late DateTime resetAt;

  Habit(this.title, this.icon, this.isBuild, this.frequency, this.customDays,
      this.goal, this.allowReminder, this.reminders);

  void resetHabit(BuildContext context) {
    DateTime now = DateTime.now();
    if (now.isAfter(resetAt)) {
      did = 0;
      setNextReset(context);
    }
  }

  void setNextReset(BuildContext context) {
    DateTime d = DateTime.now();
    DateTime now = DateTime(d.year, d.month, d.day);
    switch (frequency) {
      case "Daily":
        {
          resetAt = now.add(const Duration(days: 1));
        }
      case "Weekly":
        {
          var firstDayTZ =
              MaterialLocalizations.of(context).firstDayOfWeekIndex;
          var nowWeekDay = now.weekday % 7;
          int diff = nowWeekDay - firstDayTZ;
          if (diff < 0) diff += 7;

          DateTime firstDayOfNextweek = now.add(Duration(days: 7 - diff));
          resetAt = firstDayOfNextweek;
        }
      default:
        {
          resetAt = DateTime(now.year, now.month + 1, 0);
        }
    }
  }

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Habit.fromJson(Map<String, dynamic> json) => _$HabitFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HabitToJson(this);
}
