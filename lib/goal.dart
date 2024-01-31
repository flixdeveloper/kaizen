import 'package:auto_direction/auto_direction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/rounded_base.dart';
import 'package:kaizen/screens/goals_screen.dart';

part 'goal.g.dart';

@JsonSerializable()
class Goal {
  int type;
  String goal;
  String? customType;

  Goal(this.type, this.goal) {}

  String getTypeName() {
    switch (this.type) {
      case 0:
        return '';
      case 1:
        return 'physical'.tr();
      case 2:
        return 'emotional'.tr();
      case 3:
        return 'giving'.tr();
      case 4:
        return 'relationships'.tr();
      case 5:
        return 'family'.tr();
      case 6:
        return 'friends'.tr();
      case 7:
        return 'community'.tr();
      case 8:
        return 'career'.tr();
      case 9:
        return 'education'.tr();
      case 10:
        return 'wealth'.tr();
      case 11:
        return 'culture'.tr();
      case 12:
        return 'spiritual'.tr();
      default:
        return customType ?? '';
    }
  }

  void save({Goal? update}) {
    if (goal.isEmpty) return;
    if (update == null) {
      goals.insert(0, this);
    } else {
      update.goal = goal;
      update.type = type;
      update.customType = customType;
    }
    saveGoal(goals);
    //dismiss
  }

  Widget buildGoal(BuildContext context) {
    return Rounded(Text(goal), 20, 20);
  }

  static Future<void> buildNewGoal(BuildContext context,
      {int? type, String? customType}) async {
    Goal goal = Goal(type ?? 0, '');
    if (type == 13) goal.customType = customType;

    TextEditingController goalController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    if (customType != null) {
      categoryController.text = customType;
      goal.customType = customType;
    }

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('new_goal'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoDirection(
                  text: goal.goal,
                  child: TextField(
                    controller: goalController,
                    decoration: InputDecoration(hintText: "goal".tr()),
                    onChanged: (str) {
                      setState(() {
                        goal.goal = str;
                      });
                    },
                  ),
                ),
                Row(children: [
                  Text('category'.tr()),
                  Spacer(),
                  goal.buildDropdownType(() => setState(() {})),
                ]),
                Visibility(
                  visible: goal.type == 13,
                  child: AutoDirection(
                      text: goal.customType ?? '',
                      child: TextField(
                        controller: categoryController,
                        decoration:
                            InputDecoration(label: Text("category".tr())),
                        onChanged: (str) {
                          setState(() {
                            goal.customType = str;
                          });
                        },
                      )),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "cancel".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  goal.goal = goalController.text;
                  if (goal.goal.isEmpty) return;
                  final categoryText = categoryController.text;
                  if (categoryText.isNotEmpty)
                    goal.customType = categoryText;
                  else if (goal.type == 13) return;
                  goal.save();
                  Navigator.pop(context);
                },
                child: Text(
                  "add".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> buildUpdateGoal(BuildContext context) async {
    Goal goal = Goal(type, this.goal);
    TextEditingController goalController = TextEditingController();
    TextEditingController categoryController = TextEditingController();
    goalController.text = goal.goal;
    if (this.customType != null) {
      categoryController.text = this.customType!;
      goal.customType = this.customType!;
    }

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('update_goal'.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoDirection(
                  text: goal.goal,
                  child: TextField(
                    controller: goalController,
                    decoration: InputDecoration(hintText: "goal".tr()),
                    onChanged: (str) {
                      setState(() {
                        goal.goal = str;
                      });
                    },
                  ),
                ),
                Row(children: [
                  Text('category'.tr()),
                  Spacer(),
                  goal.buildDropdownType(() => setState(() {})),
                ]),
                Visibility(
                  visible: goal.type == 13,
                  child: AutoDirection(
                    text: goal.customType ?? '',
                    child: TextField(
                      controller: categoryController,
                      onChanged: (str) {
                        setState(() {
                          goal.customType = str;
                        });
                      },
                      decoration: InputDecoration(label: Text("category".tr())),
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () {
                  goals.remove(this);
                  saveGoal(goals);
                  Navigator.pop(context);
                },
                child: Text(
                  "delete".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                style: flatButtonStyle,
                onPressed: () {
                  goal.goal = goalController.text;
                  if (goal.goal.isEmpty) return;
                  final categoryText = categoryController.text;
                  if (categoryText.isNotEmpty)
                    goal.customType = categoryText;
                  else if (goal.type == 13) return;
                  goal.save(update: this);
                  Navigator.pop(context);
                },
                child: Text(
                  "update".tr(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Widget buildDropdownType(Function setState) {
    List<String> list = [
      'none'.tr(),
      'physical'.tr(),
      'emotional'.tr(),
      'giving'.tr(),
      'relationships'.tr(),
      'family'.tr(),
      'friends'.tr(),
      'community'.tr(),
      'career'.tr(),
      'education'.tr(),
      'wealth'.tr(),
      'culture'.tr(),
      'spiritual'.tr(),
      'custom'.tr(),
    ];

    return DropdownButton<String>(
      value: list[type],
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        type = list.indexOf(value!);
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

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$GoalToJson(this);
}
