import 'package:auto_direction/auto_direction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/note.dart';
import 'package:kaizen/reorderable_list.dart';
import 'package:kaizen/rounded_base.dart';

late List<TextEditingController> answears;
late List<String> answearsText;

Future<bool?> createEditPopup(
    BuildContext context, List<String> questions, List<String> answears) {
  List<ItemData> _items = [];
  for (int i = 0; i < questions.length; i++) {
    _items.add(ItemData(questions[i], i));
  }
  return showDialog<bool?>(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Reorderable(_items),
        );
      });
    },
  ).then((value) {
    if (value == true) updateQuestions(_items, questions, answears);
    return value;
  });
}

void updateQuestions(
    List<ItemData> items, List<String> questions, List<String> answears) {
  questions.clear();
  for (var item in items) {
    questions.add(item.title);
  }
  List<String> newA = List.generate(items.length, (_) => '');
  for (int i = 0; i < items.length; i++) {
    newA[i] = answears.elementAtOrNull(items[i].index) ?? '';
  }
  answears.clear();
  for (var item in newA) {
    answears.add(item);
  }
}

Widget buildNewNote(
    BuildContext context, List<String> questions, String title) {
  answears = List.generate(5, (_) => TextEditingController());
  answearsText = List.generate(5, (_) => '');
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    //refresh the states of Parent from ModalBottomSheet in flutter
    var size = questions.length;
    return Scaffold(
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () => createEditPopup(context, questions, answearsText)
                .then((value) => {
                      if (value == true)
                        setState(() {
                          for (int i = 0; i < answearsText.length; i++) {
                            if (i >= answears.length)
                              answears.add(TextEditingController());
                            answears[i].text = answearsText[i];
                          }
                        })
                    }),
            heroTag: null,
            child: const Icon(Icons.edit),
          ),
          SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.blueGrey,
            onPressed: () => {
              Note(title, questions, answearsForSave(size), DateTime.now())
                  .save(),
              Navigator.of(context).pop()
            },
            heroTag: null,
            child: const Icon(Icons.check),
          ),
        ]),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'PTSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: questions[index].isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text(
                              questions[index].tr(),
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Rounded(
                            AutoDirection(
                                text: answearsText[index],
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: null,
                                  keyboardType: TextInputType.multiline,
                                  minLines: minLines(size),
                                  maxLines: null,
                                  controller: answears[index],
                                  onChanged: (str) {
                                    setState(() {
                                      answearsText[index] = str;
                                    });
                                  },
                                )),
                            15,
                            15),
                        const SizedBox(height: 30)
                      ],
                    );
                    // quastions[index];
                  },
                  itemCount: size,
                ),
              ],
            ),
          ),
        ));
  });
}

Widget buildUpdateNote(BuildContext context, Note note, {bool isMiq = false}) {
  var size = note.question.length;

  List<String> questions = List.generate(size, (_) => '');

  answears = List.generate(size, (_) => TextEditingController());
  answearsText = List.generate(size, (_) => '');
  String title = note.getType();

  for (int index = 0; index < size; index++) {
    answears[index].text = note.answear[index];
    answearsText[index] = note.answear[index];
  }

  for (int index = 0; index < size; index++) {
    questions[index] = note.question[index];
  }

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    //refresh the states of Parent from ModalBottomSheet in flutter
    size = questions.length;
    return Scaffold(
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          if (!isMiq)
            FloatingActionButton(
              shape: const CircleBorder(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              onPressed: () => createEditPopup(context, questions, answearsText)
                  .then((value) => {
                        if (value == true)
                          setState(() {
                            for (int i = 0; i < answearsText.length; i++) {
                              if (i >= answears.length)
                                answears.add(TextEditingController());
                              answears[i].text = answearsText[i];
                            }
                          })
                      }),
              heroTag: null,
              child: const Icon(Icons.edit),
            ),
          if (!isMiq)
            SizedBox(
              height: 10,
            ),
          FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: Colors.blueGrey,
            onPressed: () => {
              Note(title, questions, answearsForSave(size), DateTime.now())
                  .save(update: note),
              Navigator.of(context).pop()
            },
            heroTag: null,
            child: const Icon(Icons.check),
          ),
        ]),
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'PTSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: questions[index].isNotEmpty,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 10),
                            child: Text(
                              (questions[index].isNotEmpty &&
                                      int.tryParse(questions[index]
                                              [questions[index].length - 1]) !=
                                          null)
                                  ? questions[index].tr()
                                  : questions[index],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Rounded(
                            AutoDirection(
                                text: answearsText[index],
                                child: TextField(
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: null,
                                  keyboardType: TextInputType.multiline,
                                  minLines: minLines(size),
                                  maxLines: null,
                                  controller: answears[index],
                                  onChanged: (str) {
                                    setState(() {
                                      answearsText[index] = str;
                                    });
                                  },
                                )),
                            15,
                            15),
                        const SizedBox(height: 30)
                      ],
                    );
                    // quastions[index];
                  },
                  itemCount: size,
                ),
              ],
            ),
          ),
        ));
  });
}

Widget buildViewNote(BuildContext context, Note note) {
  final date = note.getDate(context);
  List<String> answears = List.empty(growable: true);
  List<String> questions = List.empty(growable: true); //note.question;
  String title = note.getType();
  for (int index = 0; index < note.question.length; index++) {
    if (note.answear[index] != "") {
      answears.add(note.answear[index]);
      questions.add(note.question[index]);
    }
  }

  final size = questions.length;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    //refresh the states of Parent from ModalBottomSheet in flutter
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 15, 0),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(date,
                          style: const TextStyle(
                            fontFamily: 'Lobster',
                            fontStyle: FontStyle.italic,
                            //fontWeight: FontWeight.bold,
                          )),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 30, 40, 25),
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 30,
                      fontFamily: 'PTSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: questions[index].isNotEmpty,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 15),
                            child: Text(
                              questions[index].isNotEmpty &&
                                      (int.tryParse(questions[index]
                                              [questions[index].length - 1]) !=
                                          null)
                                  ? questions[index].tr()
                                  : questions[index],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                        Text(
                          answears[index],
                          maxLines: null,
                        ),
                        const SizedBox(height: 30)
                      ],
                    );
                    // quastions[index];
                  },
                  itemCount: size,
                ),
              ],
            ),
          ),
        ));
  });
}

List<String> answearsForSave(int size) {
  List<String> list = [];
  for (int i = 0; i < size; i++) {
    list.add(answears[i].text);
  }
  return list;
}

int minLines(int size) {
  if (size == 1) return 15;
  return 6;
}
