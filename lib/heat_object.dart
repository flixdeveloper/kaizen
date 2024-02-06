import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/reminder.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/settings_screen.dart';

part 'heat_object.g.dart';

@JsonSerializable(explicitToJson: true)
class Heat {
  static List<Heat> heat = [];
  static Heat todayHeat = Heat();
  List<int> did = [];
  List<int> total = [];
  late DateTime date;

  Heat() {
    DateTime d = DateTime.now();
    date = DateTime(d.year, d.month, d.day);
  }

  int getRank() {
    if (total.length == 0) return 0;
    return ((did.length / total.length) * 100).round();
  }

  String toPrint() {
    if (did.length == 1) return "accomplished_1".tr(args: ['${total.length}']);
    return "accomplished_2".tr(args: ['${did.length}', '${total.length}']);
  }

  static Heat? relevantHeat(DateTime time) {
    for (var obj in heat) {
      if (obj.date.isAtSameMomentAs(time)) return obj;
    }
    if (todayHeat.date.isAtSameMomentAs(time)) return todayHeat;
    return null;
  }

  static Map<DateTime, int> heatmap() {
    var map = <DateTime, int>{};
    for (var obj in heat) {
      map.addAll(<DateTime, int>{obj.date: obj.getRank()});
    }
    map.addAll(<DateTime, int>{todayHeat.date: todayHeat.getRank()});
    return map;
  }

  static void habitDidPlus(Habit habit, BuildContext context) {
    if (habit.frequency == '0') return;
    bool isDone = (habit.did >= habit.goal && habit.isBuild) ||
        (habit.did <= habit.goal && !habit.isBuild);
    for (var obj in heat) {
      if (!obj.date.isBefore(habit.lastReset(context)) &&
          obj.total.contains(habit.getId())) {
        if (isDone && !obj.did.contains(habit.getId())) {
          obj.did.add(habit.getId());
        } else if (!isDone && obj.did.contains(habit.getId())) {
          obj.did.remove(habit.getId());
        }
      }
    }
  }

  static Heat createTodayHeat({List<Habit>? givenHabits}) {
    List<Habit> useHabits = givenHabits ?? habits;
    final heat = Heat();
    for (var habit in useHabits) {
      if (!(habit.frequency == '0' &&
          !habit.customDays[DateTime.now().weekday % 7])) {
        if ((habit.did >= habit.goal && habit.isBuild) ||
            (habit.did <= habit.goal && !habit.isBuild))
          heat.did.add(habit.getId());
        heat.total.add(habit.getId());
      }
    }
    return heat;
  }

  //static Heat latestHeat() {
  //  Heat latest = heat[heat.length - 1];
  //  for (var obj in heat) {
  //    if (latest.date.isBefore(obj.date)) {
  //      latest = obj;
  //    }
  //  }
  //  return latest;
  //}

  static List<Heat> createMissingHeats(
      BuildContext context, List<Habit> givenHabits) {
    if (heat.isEmpty) return [];
    List<Heat> missing = [];
    final startHeat = heat[heat.length - 1];
    var newDate = startHeat.date.add(const Duration(days: 1));
    while (newDate.isBefore(todayHeat.date)) {
      var newHeat = Heat();
      newHeat.date = newDate;
      newHeat.total = startHeat.total;
      for (var obj in startHeat.did) {
        Habit? habit;
        for (var isHabit in givenHabits) {
          if (isHabit.getId() == obj) habit = isHabit;
        }
        if (habit != null) {
          if (newDate
              .isBefore(habit.nextReset(context, nextFor: startHeat.date))) {
            newHeat.did.add(obj);
          }
        }
      }

      for (var obj in todayHeat.did) {
        Habit? habit;
        for (var isHabit in givenHabits) {
          if (isHabit.getId() == obj) habit = isHabit;
        }
        if (habit != null) {
          if (!newHeat.did.contains(obj) &&
              newHeat.total.contains(obj) &&
              !newDate.isBefore(
                  habit.lastReset(context, lastFor: startHeat.date))) {
            newHeat.did.add(obj);
          }
        }
      }
      missing.add(newHeat);
      newDate = newDate.add(const Duration(days: 1));
    }
    return missing;
  }

  /// Connect the generated [_$HeatFromJson] function to the `fromJson`
  /// factory.
  factory Heat.fromJson(Map<String, dynamic> json) => _$HeatFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$HeatToJson(this);

  //static List<Heat> createMissingHeats(BuildContext context, List<Habit> givenHabits){
  //  if (heat.isEmpty) return [];
  //  List<Heat> missing = [];
  //  final startHeat = heat[heat.length - 1];
  //}
//
  //static List<Heat> createMissingHeatsAtoB(
  //    BuildContext context, Heat startHeat, Heat finishHeat, List<Habit> givenHabits) {
  //  if (heat.isEmpty) return [];
  //  List<Heat> missing = [];
  //  //final startHeat = heat[heat.length - 1];
  //  var newDate = startHeat.date.add(const Duration(days: 1));
  //  while (newDate.isBefore(finishHeat.date)) {
  //    var newHeat = Heat();
  //    newHeat.date = newDate;
  //    newHeat.total = startHeat.total;
  //    for (var obj in startHeat.did) {
  //      Habit? habit;
  //      for (var isHabit in givenHabits) {
  //        if (isHabit.getId() == obj) habit = isHabit;
  //      }
  //      if (habit != null) {
  //        if (newDate
  //            .isBefore(habit.nextReset(context, nextFor: startHeat.date))) {
  //          newHeat.did.add(obj);
  //        }
  //      }
  //    }
//
  //    for (var obj in finishHeat.did) {
  //      Habit? habit;
  //      for (var isHabit in givenHabits) {
  //        if (isHabit.getId() == obj) habit = isHabit;
  //      }
  //      if (habit != null) {
  //        if (!newHeat.did.contains(obj) &&
  //            newHeat.total.contains(obj) &&
  //            !newDate.isBefore(
  //                habit.lastReset(context, lastFor: startHeat.date))) {
  //          newHeat.did.add(obj);
  //        }
  //      }
  //    }
  //    missing.add(newHeat);
  //    newDate = newDate.add(const Duration(days: 1));
  //  }
  //  return missing;
  //}
}
