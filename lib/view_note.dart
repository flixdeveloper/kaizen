import 'package:flutter/material.dart';
import 'package:kaizen/note.dart';
import 'package:kaizen/rounded.dart';

late List<TextEditingController> answears;

Widget buildNewNote(
    BuildContext context, List<String> questions, String title) {
  answears = List.generate(5, (_) => TextEditingController());
  final size = questions.length;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    //refresh the states of Parent from ModalBottomSheet in flutter
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () => {
            Note(title, questions, answearsForSave(size)).save(),
            Navigator.of(context).pop()
          },
          child: const Icon(Icons.check),
        ),
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
                              questions[index],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Rounded(
                            TextField(
                              decoration: null,
                              keyboardType: TextInputType.multiline,
                              minLines: minLines(size),
                              maxLines: null,
                              controller: answears[index],
                            ),
                            context,
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

Widget buildUpdateNote(BuildContext context, Note note) {
  answears = List.generate(5, (_) => TextEditingController());
  String title = note.type;
  List<String> questions = note.question;
  var answear = note.answear;
  for (int index = 0; index < questions.length; index++) {
    answears[index].text = answear[index];
  }

  final size = questions.length;
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    //refresh the states of Parent from ModalBottomSheet in flutter
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          onPressed: () => {
            Note(title, questions, answearsForSave(size)).save(update: note),
            Navigator.of(context).pop()
          },
          child: const Icon(Icons.check),
        ),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                              questions[index],
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Rounded(
                            TextField(
                              decoration: null,
                              keyboardType: TextInputType.multiline,
                              minLines: minLines(size),
                              maxLines: null,
                              controller: answears[index],
                            ),
                            context,
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
  final date = note.date;
  List<String> answears = List.empty(growable: true);
  List<String> questions = List.empty(growable: true); //note.question;
  String title = note.type;
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 40, 0),
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
                  padding: const EdgeInsets.fromLTRB(40, 30, 40, 25),
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
                              questions[index],
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
