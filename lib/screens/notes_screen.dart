import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:ui' as ui;
import 'package:kaizen/view_note.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/note.dart';

late List<Note> notes;

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreen();
}

class _NotesScreen extends State<NotesScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
                alignment: Alignment.topCenter,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(50, 30, 50, 0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "notes".tr(),
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'PTSans',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 139, 128, 0),
                              minimumSize: Size(
                                  double.infinity,
                                  ((MediaQuery.of(context).size.width - 115) /
                                          8) *
                                      2),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(23), // Rounded edge
                              ),
                            ),
                            onPressed: () {
                              newNoteClick([""], "note".tr());
                            },
                            child: Text(
                              "on_your_mind".tr(),
                              style: TextStyle(
                                color: Color.fromARGB(255, 250, 250, 250),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            textDirection: ui.TextDirection.ltr,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius:
                                    (MediaQuery.of(context).size.width - 115) /
                                        8,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/sun.png'),
                                  iconSize: (MediaQuery.of(context).size.width -
                                          115) /
                                      8,
                                  onPressed: () {
                                    newNoteClick([
                                      "morning_1",
                                      "morning_2",
                                      "morning_3",
                                      "morning_4",
                                      "morning_5",
                                    ], "morning_mindset".tr());
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius:
                                    (MediaQuery.of(context).size.width - 115) /
                                        8,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/moon.png'),
                                  iconSize: (MediaQuery.of(context).size.width -
                                          115) /
                                      8,
                                  onPressed: () {
                                    newNoteClick([
                                      "evening_1",
                                      "evening_2",
                                      "evening_3",
                                      "evening_4",
                                      "evening_5",
                                    ], "evening_review".tr());
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius:
                                    (MediaQuery.of(context).size.width - 115) /
                                        8,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/week.png'),
                                  iconSize: (MediaQuery.of(context).size.width -
                                          115) /
                                      8,
                                  onPressed: () {
                                    newNoteClick([
                                      "weekly_1",
                                      "weekly_2",
                                      "weekly_3",
                                      "weekly_4",
                                      "weekly_5",
                                    ], "weekly_review".tr());
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius:
                                    (MediaQuery.of(context).size.width - 115) /
                                        8,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/month.png'),
                                  iconSize: (MediaQuery.of(context).size.width -
                                          115) /
                                      8,
                                  onPressed: () {
                                    newNoteClick([
                                      "monthly_1",
                                      "monthly_2",
                                      "monthly_3",
                                      "monthly_4",
                                      "monthly_5",
                                    ], "monthly_review".tr());
                                  },
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            padding: const EdgeInsets.only(top: 15, bottom: 30),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: notes.length,
                            itemBuilder: (context, noteItem) {
                              Note note = notes[noteItem];
                              return Column(children: [
                                const SizedBox(height: 15),
                                Slidable(
                                    startActionPane: ActionPane(
                                      // A motion is a widget used to control how the pane animates.
                                      motion: const ScrollMotion(),

                                      // A pane can dismiss the Slidable.
                                      //dismissible:
                                      //    DismissiblePane(onDismissed: () {}),

                                      // All actions are defined in the children parameter.
                                      children: [
                                        // A SlidableAction can have an icon and/or a label.
                                        SlidableAction(
                                          onPressed: (context) => {
                                            setState(() {
                                              notes.removeAt(noteItem);
                                              saveNote(notes);
                                            })
                                          },
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          backgroundColor:
                                              const Color(0xFFFE4A49),
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete,
                                          label: 'delete'.tr(),
                                        ),
                                        SlidableAction(
                                          onPressed: (context) =>
                                              {updateNote(note)},
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          backgroundColor:
                                              const Color(0xFF21B7CA),
                                          foregroundColor: Colors.white,
                                          icon: Icons.edit,
                                          label: 'edit'.tr(),
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      onTap: () => {
                                        viewNote(note),
                                        Feedback.forTap(context),
                                      },
                                      child: note.buildNote(context),
                                    ))
                              ]);
                            },
                          ),
                        ])))
          ]),
    )));
  }

  void newNoteClick(List<String> quastions, String title) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (contetxt) => buildNewNote(
            context,
            quastions,
            title,
          ),
        )).then((_) {
      setState(() {});
    });
  }

  void updateNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contetxt) => buildUpdateNote(context, note),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  void viewNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contetxt) => buildViewNote(context, note),
      ),
    );
  }
}
