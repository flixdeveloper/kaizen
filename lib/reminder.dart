import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/add_habit.dart';
import 'package:weekday_selector/weekday_selector.dart';

part 'reminder.g.dart';

@JsonSerializable()
class Reminder {
  int id = UniqueKey().hashCode;
  DateTime time;
  List<bool> days;

  Reminder(this.time, this.days);

  void update(DateTime time, List<bool> days) {
    this.time = time;
    this.days = days;
  }

  /// Connect the generated [_$ReminderFromJson] function to the `fromJson`
  /// factory.
  factory Reminder.fromJson(Map<String, dynamic> json) =>
      _$ReminderFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ReminderToJson(this);
}

Widget reminderPick(
    BuildContext context, Function refreshParent, Reminder? update) {
  DateTime time;
  List<bool> customDaysSet;
  if (update != null) {
    time =
        DateTime.fromMillisecondsSinceEpoch(update.time.millisecondsSinceEpoch);
    customDaysSet = update.days.toList();
    //change every item in customDaysSet so it will be false if customDays[*same index*] is false?
  } else {
    time = DateTime.now();
    customDaysSet = List<bool>.filled(7, true);
  }
  if (frequency == 'Daily') {
    for (int i = 0; i < customDaysSet.length; i++) {
      if (customDays[i] == false) customDaysSet[i] = false;
    }
  }
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set reminder'),
      ),
      //body: Container(
      //  height: MediaQuery.of(context).size.height * .35,
      //  child: CupertinoDatePicker(
      //    initialDateTime: time,
      //    mode: CupertinoDatePickerMode.time,
      //    use24hFormat: true,
      //    // This is called when the user changes the time.
      //    onDateTimeChanged: (DateTime newTime) {
      //      time = newTime;
      //      //refreshParent();
      //    },
      //  ),
      //),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .25,
              child: CupertinoDatePicker(
                initialDateTime: time,
                mode: CupertinoDatePickerMode.time,
                use24hFormat: MediaQuery.of(context).alwaysUse24HourFormat,
                // This is called when the user changes the time.
                onDateTimeChanged: (DateTime newTime) {
                  time = newTime;
                  //refreshParent();
                },
              ),
            ),
            WeekdaySelector(
              //selectedFillColor: Colors.red,
              firstDayOfWeek:
                  MaterialLocalizations.of(context).firstDayOfWeekIndex,
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              onChanged: (int day) {
                setState(() {
                  // Use module % 7 as Sunday's index in the array is 0 and
                  // DateTime.sunday constant integer value is 7.
                  final index = day % 7;
                  // We "flip" the value in this example, but you may also
                  // perform validation, a DB write, an HTTP call or anything
                  // else before you actually flip the value,
                  // it's up to your app's needs.
                  if (frequency == 'Daily') {
                    if (customDays[index]) {
                      customDaysSet[index] = !customDaysSet[index];
                    }
                  } else {
                    customDaysSet[index] = !customDaysSet[index];
                  }
                });
              },
              values: customDaysSet,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                if (update != null)
                  Expanded(
                      child: Visibility(
                    visible: true, //////////////////////
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .redAccent, //Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded edge
                        ),
                      ),
                      onPressed: () {
                        reminders.remove(update);
                        Navigator.pop(context);
                        refreshParent();
                      },
                      child: const Text(
                        "Delete",
                      ),
                    ),
                  )),
                if (update != null) const SizedBox(width: 20), /////////////////
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: (update == null)
                            ? MediaQuery.of(context).size.width / 3.75
                            : 0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20), // Rounded edge
                        ),
                      ),
                      onPressed: () {
                        if (update != null) {
                          update.update(time, customDaysSet);
                        } else {
                          Reminder reminder = Reminder(time, customDaysSet);
                          reminders.add(reminder);
                        }
                        Navigator.pop(context);
                        refreshParent();
                      },
                      child: const Text(
                        "Confirm",
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  });
}

void reminderPickSheet(BuildContext context, Function refreshParent,
    {Reminder? update}) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    //TODO: change builder
    context: context,
    builder: (context) {
      return FractionallySizedBox(
        heightFactor: 0.5,
        child: reminderPick(context, refreshParent, update), //fix this line?
      );
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    clipBehavior: Clip.hardEdge,
  );
}
