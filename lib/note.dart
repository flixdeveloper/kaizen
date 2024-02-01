import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/rounded_base.dart';
import 'package:kaizen/screens/notes_screen.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note {
  String type;
  DateTime dateTime;
  List<String> question;
  List<String> answear;

  Note(this.type, this.question, this.answear, this.dateTime) {
    this.type = typeToNum();
    //this.dateTime = DateTime.now();
    //date = DateFormat('EEEE, MMM d').format(currentDate); //Thursday, Sep 28
  }

  String typeToNum() {
    int? num = int.tryParse(type);
    if (num != null) return type;
    if (type == 'Note' || type == 'note'.tr()) return '0';
    if (type == 'Evening Review' || type == 'evening_review'.tr()) return '2';
    if (type == 'Weekly Review' || type == 'weekly_review'.tr()) return '3';
    if (type == 'Monthly Review' || type == 'monthly_review'.tr()) return '4';
    if (type == 'MIQ') return '5';
    return '1'; //'morning_mindset'.tr()
  }

  void fixQuestions() {
    for (var i = 0; i < question.length; i++) {
      switch (question[i]) {
        case "What am I grateful for today?":
          question[i] = 'morning_1';
          break;
        case "What are my top priorities for the day?":
          question[i] = 'morning_2';
          break;
        case "How can I make today successful and fulfilling?":
          question[i] = 'morning_3';
          break;
        case "What positive mindset or attitude can I adopt today?":
          question[i] = 'morning_4';
          break;
        case "How can I take care of my physical and mental well-being today?":
          question[i] = 'morning_5';
          break;
        case "What were my accomplishments and successes today?":
          question[i] = 'evening_1';
          break;
        case "What challenges did I face and how did I handle them?":
          question[i] = 'evening_2';
          break;
        case "Did I live up to my values and principles today?":
          question[i] = 'evening_3';
          break;
        case "What lessons did I learn from today's experiences?":
          question[i] = 'evening_4';
          break;
        case "How can I improve or adjust my approach for tomorrow?":
          question[i] = 'evening_5';
          break;
        case "What were my major achievements and progress this week?":
          question[i] = 'weekly_1';
          break;
        case "Did I meet my weekly goals and objectives?":
          question[i] = 'weekly_2';
          break;
        case "What tasks or projects are still pending and need attention?":
          question[i] = 'weekly_3';
          break;
        case "What obstacles or setbacks did I encounter and how can I overcome them?":
          question[i] = 'weekly_4';
          break;
        case "How can I make next week more productive and fulfilling?":
          question[i] = 'weekly_5';
          break;
        case "What were my biggest accomplishments and milestones this month?":
          question[i] = 'monthly_1';
          break;
        case "Did I achieve the goals I set at the beginning of the month?":
          question[i] = 'monthly_2';
          break;
        case "What areas of my life or work need improvement or adjustment?":
          question[i] = 'monthly_3';
          break;
        case "How did I manage my time and priorities this month?":
          question[i] = 'monthly_4';
          break;
        case "What can I do differently or better in the upcoming month?":
          question[i] = 'monthly_5';
          break;
      }
    }
  }

  String getDate(BuildContext context) {
    //DateTime tmpDate = new DateFormat('EEEE, MMM d').parse(date);

    final DateFormat formatter =
        DateFormat('EEEE, d MMM', context.locale.toString());
    final String formatted = formatter.format(dateTime);
    return formatted;
  }

  String getType() {
    switch (this.type) {
      case '0':
        return 'note'.tr();
      case '2':
        return 'evening_review'.tr();
      case '3':
        return 'weekly_review'.tr();
      case '4':
        return 'monthly_review'.tr();
      case '5':
        return 'MIQ';
      default:
        return 'morning_mindset'.tr();
    }
  }

  String firstAnswear() {
    for (var i = 0; i < question.length; i++) {
      if (answear[i] != "") {
        return answear[i];
      }
    }
    return "";
  }

  void save({Note? update}) {
    //////////////////////////////////////
    if (firstAnswear() == "") return;
    if (update == null) {
      notes.insert(0, this);
    } else {
      update.question = question;
      update.answear = answear;
    }
    if (type == '5') {
      saveMiq(this);
    } else {
      saveNote(notes);
    }
    //dismiss
  }

  Widget buildNote(BuildContext context) {
    return Rounded(
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getDate(context),
                  style: const TextStyle(
                    fontFamily: 'Lobster',
                    fontStyle: FontStyle.italic,
                    //fontWeight: FontWeight.bold,
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: type != '0',
                  child: Rounded(
                    Text(getType(),
                        style: const TextStyle(
                          fontFamily: 'RobotoCondensed',
                        )),
                    5,
                    5,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Text(firstAnswear()),
          )
        ]),
        20,
        20);
  }

  /// Connect the generated [_$PersonFromJson] function to the `fromJson`
  /// factory.
  factory Note.fromJson(Map<String, dynamic> json) => _$NoteFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NoteToJson(this);
}
