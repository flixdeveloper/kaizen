import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/rounded_base.dart';
import 'package:kaizen/screens/notes_screen.dart';

part 'note.g.dart';

@JsonSerializable(explicitToJson: true)
class Note {
  String type;
  late String date;
  List<String> question;
  List<String> answear;

  Note(this.type, this.question, this.answear) {
    DateTime currentDate = DateTime.now();
    date = DateFormat('EEEE, MMM d').format(currentDate); //Thursday, Sep 28
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
    if (firstAnswear() == "") return;
    if (update == null) {
      notes.add(this);
    } else {
      update.answear = answear;
    }
    saveNote(notes);
    //dismiss
  }

  Widget buildNote(BuildContext context) {
    return Rounded(
        Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date,
                  style: const TextStyle(
                    fontFamily: 'Lobster',
                    fontStyle: FontStyle.italic,
                    //fontWeight: FontWeight.bold,
                  )),
              Align(
                alignment: Alignment.topRight,
                child: Visibility(
                  visible: type != "Note",
                  child: Rounded(
                    Text(type,
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
            alignment: Alignment.topLeft,
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
