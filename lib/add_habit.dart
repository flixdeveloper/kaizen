import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/icon_pick.dart';
import 'package:kaizen/notification_service.dart';
import 'package:kaizen/reminder.dart';
import 'package:kaizen/rounded_base.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddHabit extends StatefulWidget {
  final Habit? habit;
  const AddHabit({super.key, this.habit});
  @override
  State<AddHabit> createState() => _AddHabit();
}

final TextEditingController titleController = TextEditingController();
int selectedIcon = 0;
bool isBuild = true;
String frequency = 'Daily';
List<bool> customDays = List.filled(7, true);
int goal = 1;
bool allowReminder = false;
List<Reminder> reminders = [];

class _AddHabit extends State<AddHabit> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final habit = widget.habit;
    if (habit != null) {
      titleController.text = habit.title;
      selectedIcon = habit.icon;
      isBuild = habit.isBuild;
      frequency = habit.frequency;
      customDays = habit.customDays;
      goal = habit.goal;
      allowReminder = habit.allowReminder;
      reminders = habit.reminders;
    }
  }

  @override
  void dispose() {
    titleController.clear();
    selectedIcon = 0;
    isBuild = true;
    frequency = 'Daily';
    customDays = List.filled(7, true);
    goal = 1;
    allowReminder = false;
    reminders = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('New Habit'),
          ),
          body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    80, 35, 80, 20), //add padding here
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Rounded(
                                TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                  autofocus: true,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  controller: titleController,
                                ),
                                0,
                                10),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => {
                                iconPickSheet(context, () => setState(() {})),
                                Feedback.forTap(context)
                              },
                              child: Rounded(
                                  Row(
                                    //navigate to next screen!!!
                                    //Navigator.push(context, MaterialPageRoute(builder: (contetxt) => IconPickScreen(),),);
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Icon'),
                                      const Spacer(),
                                      Image.asset(
                                        'assets/icons/habit_icon ($selectedIcon).png',
                                        width: 28,
                                        height: 28,
                                      ),
                                      Image.asset('assets/images/next.png',
                                          scale: 3),

                                      //reminder
                                    ],
                                  ),
                                  15,
                                  10),
                            ),
                            const SizedBox(height: 25),
                            ToggleSwitch(
                              minHeight: 50,
                              minWidth:
                                  MediaQuery.of(context).size.width / 2 - 80.5,
                              initialLabelIndex: (isBuild ? 0 : 1),
                              totalSwitches: 2,
                              labels: const ['Build habit', 'Break habit'],
                              onToggle: (index) {
                                setState(() {
                                  isBuild = index == 0;
                                });
                              },
                            ),
                            const SizedBox(height: 10),
                            Rounded(
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Frequency'),
                                    const Spacer(),
                                    buildDropdownFreq(() => setState(() {})),
                                  ],
                                ),
                                15,
                                10),
                            const SizedBox(height: 10),
                            Visibility(
                              visible: frequency == 'Daily',
                              child: Column(
                                children: [
                                  WeekdaySelector(
                                    firstDayOfWeek:
                                        MaterialLocalizations.of(context)
                                            .firstDayOfWeekIndex,
                                    //selectedFillColor: Colors.red,
                                    //fillColor: Theme.of(context)
                                    //    .colorScheme
                                    //    .primaryContainer,
                                    onChanged: (int day) {
                                      setState(() {
                                        // Use module % 7 as Sunday's index in the array is 0 and
                                        // DateTime.sunday constant integer value is 7.
                                        final index = day % 7;
                                        // We "flip" the value in this example, but you may also
                                        // perform validation, a DB write, an HTTP call or anything
                                        // else before you actually flip the value,
                                        // it's up to your app's needs.
                                        customDays[index] = !customDays[index];
                                      });
                                    },
                                    values: customDays,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),

                            Rounded(
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        (isBuild == true) ? 'Goal' : 'Maximum'),
                                    const Spacer(),
                                    //var list = [for (var i = 1; i <= 10; i++) i];
                                    //buildDropdownGoal(() => setState(() {})),

                                    CartStepperInt(
                                      style: CartStepperStyle.fromColorScheme(
                                          Theme.of(context).colorScheme,
                                          iconPlus: Icons.add,
                                          iconMinus: Icons.remove),
                                      value: goal,
                                      size: 24,
                                      didChangeCount: (count) {
                                        setState(() {
                                          if (count > 0 && count < 100) {
                                            goal = count;
                                          }
                                        });
                                      },
                                    ),
                                    //reminder
                                  ],
                                ),
                                25,
                                10),

                            const SizedBox(height: 25),
                            Rounded(
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Remind me'),
                                          const Spacer(),
                                          Switch.adaptive(
                                            value: allowReminder,
                                            onChanged: (change) => {
                                              //if (change)
                                              //  askNotificationPremission(),
                                              allowReminder = change,
                                              setState(() {}),
                                            },
                                          ),
                                        ],
                                      ),
                                      Visibility(
                                          visible: allowReminder,
                                          child: Column(children: [
                                            Wrap(
                                                spacing:
                                                    12.0, // gap between adjacent chips
                                                runSpacing:
                                                    10.0, // gap between lines
                                                children: [
                                                  for (var reminder
                                                      in reminders)
                                                    ElevatedButton(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  40), // Rounded edge
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        reminderPickSheet(
                                                            context,
                                                            () =>
                                                                setState(() {}),
                                                            update: reminder);
                                                      },
                                                      child: Text(
                                                        (MediaQuery.of(context)
                                                                .alwaysUse24HourFormat)
                                                            ? DateFormat.Hm()
                                                                .format(reminder
                                                                    .time)
                                                            : DateFormat(
                                                                    "h:mm a")
                                                                .format(reminder
                                                                    .time),
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .background),
                                                      ),
                                                    ),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                40), // Rounded edge
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      reminderPickSheet(
                                                          context,
                                                          () =>
                                                              setState(() {}));
                                                    },
                                                    child: Text(
                                                      "+",
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background),
                                                    ),
                                                  )
                                                ]),
                                            const SizedBox(height: 10),
                                          ])),
                                    ]),
                                2,
                                10),

                            const SizedBox(height: 35),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                                minimumSize: const Size(double.infinity, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15), // Rounded edge
                                ),
                              ),
                              onPressed: () {
                                var notificationService = NotificationService();
                                String title = titleController.text;
                                var oldHabit = widget.habit;
                                if (oldHabit != null) {
                                  notificationService.cancelSchedule(oldHabit);
                                  oldHabit.title = title;
                                  oldHabit.icon = selectedIcon;
                                  oldHabit.isBuild = isBuild;
                                  oldHabit.frequency = frequency;
                                  oldHabit.customDays = customDays;
                                  oldHabit.goal = goal;
                                  oldHabit.allowReminder = allowReminder;
                                  oldHabit.reminders = reminders;
                                  oldHabit.setNextReset(context);
                                  notificationService
                                      .setNotifications(oldHabit);
                                } else {
                                  Habit habit = Habit(
                                      title,
                                      selectedIcon,
                                      isBuild,
                                      frequency,
                                      customDays,
                                      goal,
                                      allowReminder,
                                      reminders);
                                  habit.setNextReset(context);
                                  habits.add(habit);
                                  notificationService.setNotifications(habit);
                                }
                                saveHabit(habits);
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                (widget.habit != null)
                                    ? "Save habit"
                                    : "Add habit",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 250, 250, 250),
                                  fontSize: 18,
                                ),
                              ),
                            )
                            //style the button like rounded.dart but with dark blue color?
                          ],
                        )),
                  ],
                )),
          )),
    );
  }

  Widget buildDropdownFreq(Function setState) {
    List<String> list = ['Daily', 'Weekly', 'Monthly'];
    return DropdownButton<String>(
      value: frequency,
      icon: Image.asset('assets/images/next.png', scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        frequency = value!;
        setState();
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

//Widget buildNewHabit(BuildContext context, {Habit? habit}) {}

//askNotificationPremission() {
//  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//      FlutterLocalNotificationsPlugin();
//  flutterLocalNotificationsPlugin
//      .resolvePlatformSpecificImplementation<
//          AndroidFlutterLocalNotificationsPlugin>()
//      ?.requestNotificationsPermission();
//}


