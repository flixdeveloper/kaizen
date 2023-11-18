import 'package:flutter/material.dart';
import 'package:kaizen/add_habit.dart';

void iconPickSheet(BuildContext context, Function refreshParent) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return FractionallySizedBox(
          heightFactor: 0.62,
          child: iconPick(context, refreshParent) //fix this line?
          );
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    clipBehavior: Clip.hardEdge,
  );
}

Widget iconPick(BuildContext context, Function refreshParent) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Pick an icon'),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment(-0.65, 0),
                    child: Text(
                      "Icons:",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                      child: Wrap(
                          spacing: 12.0, // gap between adjacent chips
                          runSpacing: 10.0, // gap between lines
                          children: [
                        for (var i = 0; i <= 33; i++)
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedIcon = i;
                                  refreshParent();
                                });
                              },
                              child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: selectedIcon == i
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Colors.transparent,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Image.asset(
                                    'assets/icons/habit_icon ($i).png',
                                    width: 48,
                                    height: 48,
                                  ))),
                      ]))
                ],
              )),
        ));
  });
}
