import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kaizen/goal.dart';
import 'dart:ui' as ui;
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/goal.dart';
import 'package:kaizen/rounded_base.dart';

late List<Goal> goals;

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreen();
}

int containsType(int type, List<List<Goal>> goalsByType) {
  for (var n = 0; n < goalsByType.length; n++) {
    var item = goalsByType[n];
    var checkType = item[0].type;
    if (checkType == type) return n;
  }
  return -1;
}

class _GoalsScreen extends State<GoalsScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    List<List<Goal>> goalsByType = List.empty(growable: true);
    for (var goal in goals) {
      var index = containsType(goal.type, goalsByType);
      if (index == -1) {
        goalsByType.insert(0, [goal]);
      } else {
        goalsByType[index].add(goal);
      }
    }
    if (goalsByType.length >= 2) {
      goalsByType.sort((a, b) => a[0].type.compareTo(b[0].type));
      final customList = goalsByType[goalsByType.length - 1];
      if (customList[0].type == 13) {
        customList.sort((a, b) => a.customType!.compareTo(b.customType!));
        List<List<Goal>> customLists = [];
        for (var goal in customList) {
          if (customLists.isEmpty ||
              customLists[customLists.length - 1][0].customType! !=
                  goal.customType!)
            customLists.add([goal]);
          else {
            customLists[customLists.length - 1].add(goal);
          }
        }
        goalsByType.removeLast();
        goalsByType.addAll(customLists);
      }
    }

    List<Widget> goalsWidget = List.empty(growable: true);
    for (var list in goalsByType) {
      goalsWidget.add((list[0].type == 0)
          ? SizedBox(height: 40)
          : Padding(
              padding: EdgeInsets.fromLTRB(80, 40, 80, 10),
              child: Text(
                list[0].getTypeName(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ));
      goalsWidget.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 40),
          child: groupGoals(list)));
    }

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.blueGrey,
        onPressed: () => {
          Goal.buildNewGoal(context).then((_) {
            setState(() {});
          })
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 10),
              child: Text(
                "goals".tr(),
                style: TextStyle(
                  fontSize: 35,
                  fontFamily: 'PTSans',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            for (var widget in goalsWidget) widget,
            //GroupGoals(daily),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Widget groupGoals(List<Goal> goalsByType) {
    return Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12.0, // gap between adjacent chips
        runSpacing: 10.0, // gap between lines
        children: [
          for (var goal in goalsByType)
            GestureDetector(
              onTap: () => {
                goal.buildUpdateGoal(context).then((_) => setState(() {})),
                Feedback.forTap(context),
              },
              child: goal.buildGoal(context),
            ),
          //Slidable(
          //    startActionPane: ActionPane(
          //      motion: const ScrollMotion(),
          //      children: [
          //        SlidableAction(
          //          onPressed: (context) => {
          //            goals.remove(goal),
          //            saveGoal(goals),
          //            setState(() {}),
          //          },
          //          borderRadius: BorderRadius.circular(20),
          //          backgroundColor: const Color(0xFFFE4A49),
          //          foregroundColor: Colors.white,
          //          icon: Icons.delete,
          //          label: 'delete'.tr(),
          //        ),
          //      ],
          //    ),
          //    child: GestureDetector(
          //      onTap: () => {
          //        goal.buildUpdateGoal(context).then((_) => setState(() {})),
          //        Feedback.forTap(context),
          //      },
          //      child: goal.buildGoal(context),
          //    )),

          GestureDetector(
            onTap: () => {
              Goal.buildNewGoal(context,
                      type: goalsByType[0].type,
                      customType: goalsByType[0].customType)
                  .then((_) {
                setState(() {});
              })
            },
            child: Rounded(
              Text('+'),
              20,
              20,
              round: 15,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

          //ElevatedButton(
          //  style: ElevatedButton.styleFrom(
          //    backgroundColor:
          //        Colors.grey.shade800, //Theme.of(context).colorScheme.primary,
          //    shape: RoundedRectangleBorder(
          //      borderRadius: BorderRadius.circular(40), // Rounded edge
          //    ),
          //  ),
          //  onPressed: () {
          //    //reminderPickSheet(
          //    //    context,
          //    //    () =>
          //    //        setState(() {}));
          //  },
          //  child: Text(
          //    "+",
          //    //style: TextStyle(color: Colors.white),
          //  ),
          //),
        ]);
  }

/*

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 40),
      itemCount: goalsByType.length,
      separatorBuilder: (context, index) => const SizedBox(height: 15),
      itemBuilder: (context, goalItem) {
        Goal goal = goalsByType[goalItem];
        return Slidable(
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => {
                    goals.remove(goal),
                    saveGoal(goals),
                    setState(() {}),
                  },
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'delete'.tr(),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () => {
                goal.buildUpdateGoal(context).then((_) => setState(() {})),
                Feedback.forTap(context),
              },
              child: goal.buildGoal(context),
            ));
      },
    );
  }
  */
}
