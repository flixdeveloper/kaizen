import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
                          const Text(
                            "Notes",
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
                                  (MediaQuery.of(context).size.width / 5 -
                                          45.5) *
                                      2),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(23), // Rounded edge
                              ),
                            ),
                            onPressed: () {
                              newNoteClick([""], "Note");
                            },
                            child: const Text(
                              "What's on your mind?",
                              style: TextStyle(
                                color: Color.fromARGB(255, 250, 250, 250),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 5 -
                                    45.5,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/sun.png'),
                                  iconSize:
                                      MediaQuery.of(context).size.width / 5 -
                                          45.5,
                                  onPressed: () {
                                    newNoteClick([
                                      "What am I grateful for today?",
                                      "What are my top priorities for the day?",
                                      "How can I make today successful and fulfilling?",
                                      "What positive mindset or attitude can I adopt today?",
                                      "How can I take care of my physical and mental well-being today?",
                                    ], "Morning mindset");
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 5 -
                                    45.5,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/moon.png'),
                                  iconSize:
                                      MediaQuery.of(context).size.width / 5 -
                                          45.5,
                                  onPressed: () {
                                    newNoteClick([
                                      "What were my accomplishments and successes today?",
                                      "What challenges did I face and how did I handle them?",
                                      "Did I live up to my values and principles today?",
                                      "What lessons did I learn from today's experiences?",
                                      "How can I improve or adjust my approach for tomorrow?",
                                    ], "Evening Review");
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 5 -
                                    45.5,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/week.png'),
                                  iconSize:
                                      MediaQuery.of(context).size.width / 5 -
                                          45.5,
                                  onPressed: () {
                                    newNoteClick([
                                      "What were my major achievements and progress this week?",
                                      "Did I meet my weekly goals and objectives?",
                                      "What tasks or projects are still pending and need attention?",
                                      "What obstacles or setbacks did I encounter and how can I overcome them?",
                                      "How can I make next week more productive and fulfilling?",
                                    ], "Weekly Review");
                                  },
                                ),
                              ),
                              const SizedBox(width: 5),
                              CircleAvatar(
                                radius: MediaQuery.of(context).size.width / 5 -
                                    45.5,
                                backgroundColor:
                                    Theme.of(context).colorScheme.tertiary,
                                child: IconButton(
                                  padding: const EdgeInsets.all(15),
                                  icon: Image.asset('assets/images/month.png'),
                                  iconSize:
                                      MediaQuery.of(context).size.width / 5 -
                                          45.5,
                                  onPressed: () {
                                    newNoteClick([
                                      "What were my biggest accomplishments and milestones this month?",
                                      "Did I achieve the goals I set at the beginning of the month?",
                                      "What areas of my life or work need improvement or adjustment?",
                                      "How did I manage my time and priorities this month?",
                                      "What can I do differently or better in the upcoming month?",
                                    ], "Monthly Review");
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
                                          label: 'Delete',
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
                                          label: 'Edit',
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
