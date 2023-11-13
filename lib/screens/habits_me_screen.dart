import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kaizen/add_habit.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/notification_service.dart';
import 'package:kaizen/rounded.dart';

late List<Habit> habits;

class HabitsMeScreen extends StatefulWidget {
  const HabitsMeScreen({super.key});

  @override
  State<HabitsMeScreen> createState() => _HabitsMeScreen();
}

class _HabitsMeScreen extends State<HabitsMeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<Habit> daily = List.empty(growable: true);
    List<Habit> weekly = List.empty(growable: true);
    List<Habit> monthly = List.empty(growable: true);
    for (var habit in habits) {
      if (habit.frequency == "Daily") {
        daily.add(habit);
      } else if (habit.frequency == "Weekly") {
        weekly.add(habit);
      } else {
        monthly.add(habit);
      }
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () => {
          //addHabbitSheet(context),
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (contetxt) => const AddHabit(),
            ),
          ).then((_) {
            setState(() {});
          })
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(50, 80, 50, 50),
              child: Text(
                "Habits",
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'PTSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (daily.isNotEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(80, 0, 80, 10),
                child: Text(
                  'Daily',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            if (daily.isNotEmpty) GroupHabits(daily),
            if (weekly.isNotEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                child: Text(
                  'Weekly',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            if (weekly.isNotEmpty) GroupHabits(weekly),
            if (monthly.isNotEmpty)
              const Padding(
                padding: EdgeInsets.fromLTRB(80, 10, 80, 10),
                child: Text(
                  'Monthly',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            if (monthly.isNotEmpty) GroupHabits(monthly),
          ],
        ),
      ),
    );
  }

  Widget GroupHabits(List<Habit> habitsByType) {
    return ListView.separated(
      reverse: true,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 40),
      itemCount: habitsByType.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, habitItem) {
        Habit habit = habitsByType[habitItem];
        return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {
                    NotificationService().cancelSchedule(habit),
                    //deleteHabit(habit),
                    habits.remove(habit),
                    saveHabit(habits),
                    setState(() {}),
                  },
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
                SlidableAction(
                  onPressed: (context) => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (contetxt) => AddHabit(habit: habit),
                      ),
                    ).then((_) => setState(() {})),
                  },
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => {
                //action
                habit.did++,
                saveHabit(habits),
                Feedback.forTap(context),
                setState(() {})
              },
              child: getHabitItem(context, habit),
            ));
      },
    );
  }

  Widget getHabitItem(BuildContext context, Habit habit) {
    return Rounded(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/icons/habit_icon (${habit.icon}).png',
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text((habit.isBuild)
                    ? "Goal: ${habit.goal}"
                    : "Maximum: ${habit.goal}"),
              ],
            ),
            const Spacer(),
            TweenAnimationBuilder(
                key: ValueKey(habit.did),
                duration: const Duration(seconds: 1),
                curve: Curves.elasticOut,
                tween: Tween<double>(begin: 0.5, end: 1.1),
                builder: (context, value, _) {
                  return Transform.scale(
                      scale: (value - 0.8).abs() + 0.8,
                      child: Stack(children: [
                        inCircle(habit),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: (habit.did - 1) / habit.goal,
                                end: habit.did / habit.goal),
                            duration: const Duration(milliseconds: 400),
                            builder: (context, value, _) =>
                                CircularProgressIndicator(
                                    value: value,
                                    backgroundColor: ((!habit.isBuild)
                                        ? Colors.green
                                        : Colors.grey),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        (habit.isBuild)
                                            ? Colors.green
                                            : Colors.green.shade200)),
                          ),
                        ),
                      ]));
                }),
          ],
        ),
        context,
        20,
        20,
        round: 20);
  }
}

Widget inCircle(Habit habit) {
  if (habit.did == habit.goal) {
    return TweenAnimationBuilder(
        curve: Curves.decelerate,
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, _) {
          return SizeTransition(
            sizeFactor: AlwaysStoppedAnimation(value),
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.check,
                    color: Color.fromARGB(255, 170, 177, 144), size: 32)),
          );
        });
  }
  return Positioned.fill(
      child: Align(
    alignment: Alignment.center,
    child: Text(
      habit.did.toString(),
      style: ((habit.did >= habit.goal && habit.isBuild) ||
              (habit.did <= habit.goal && !habit.isBuild))
          ? const TextStyle(
              color: Color.fromARGB(255, 170, 177, 144),
              fontWeight: FontWeight.bold)
          : (!habit.isBuild)
              ? const TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold)
              : const TextStyle(),
    ),
  ));
}
