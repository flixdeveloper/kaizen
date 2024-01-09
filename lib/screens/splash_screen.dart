import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/main.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/home_screen.dart';
import 'package:kaizen/screens/login_screen.dart';
import 'package:kaizen/screens/notes_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    timer = Timer(const Duration(seconds: 7), () => replaceScreen());
  }

  Future<void> replaceScreen() async {
    var nextScreen = await getNext(context);
    try {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => nextScreen,
        ),
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var sentence = getSentence(DateTime.now().day);
    return Scaffold(
      body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            replaceScreen();
            timer.cancel();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 180, 0, 0), //add padding here
                  child: Text(
                    'KaiZen',
                    style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'kaushanScript',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Align(
                alignment: const Alignment(0.0, -0.4),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            '“',
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 60.0, 0.0, 90.0),
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Text(
                                  sentence[0],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                ),
                                if (sentence.length == 2)
                                  const SizedBox(height: 10),
                                if (sentence.length == 2)
                                  Text(
                                    "~ ${sentence[1]}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            '”',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.fromLTRB(0, 0, 0, 40), //add padding here
                  //change padding to be only from bottom?
                  child: Text(
                    'TAP TO DISMISS',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

Future<Widget> getNext(BuildContext context) async {
  try {
    if (FirebaseAuth.instance.currentUser != null) {
      initSettings(context);
      initMeditation();
      habits = await getHabits();
      notes = await getNotes();
      homeWidgets = await getHomeWidgets();
      return const MyHomePage();
    }
  } catch (e) {}
  return const LoginScreen();
}

List<String> getSentence(int num) {
  switch (num) {
    //case 0:
    //  return [
    //    "Life is like a ladder. You need to take one step at a time to reach the top."
    //  ];
    case 1:
      return [
        "The best way to predict the future is to create it.",
        "Abraham Lincoln"
      ];
    case 2:
      return [
        "Life is not always perfect, but that doesn’t mean you can’t enjoy it."
      ];
    case 3:
      return [
        "The most important thing in life is not what you have, but who you are.",
        "Oprah Winfrey"
      ];
    case 4:
      return [
        "The key to happiness is to find what you love to do and make it your profession.",
        "Steven Covey"
      ];
    case 5:
      return ["Life is too short to waste it on things you don’t love."];
    case 6:
      return [
        "The best way to start a new day is to forgive yourself for the past."
      ];
    //case 7:
    //  return [
    //    "The best way to look forward is to focus on what you want to achieve, not what you fear."
    //  ];
    case 8:
      return [
        "The best way to make a dream come true is to wake up and start working on it.",
        "Nelson Mandela"
      ];
    case 9:
      return [
        "The best way to overcome fear is to confront it.",
        "Albert Einstein"
      ];
    case 10:
      return [
        "The best way to find yourself is to lose yourself in something greater.",
        "Albert Einstein"
      ];
    case 11:
      return ["The best way to find love is to be loving.", "Buddha"];
    case 12:
      return ["The best way to learn is to teach.", "John Dewey"];
    case 13:
      return [
        "The best way to start over is to stop trying to start over.",
        "Steven Covey"
      ];
    case 14:
      return [
        "The best way to stop worrying is to start doing something.",
        "Steven Covey"
      ];
    //case 15:
    //  return [
    //    "The best way to feel good about yourself is to help others feel good about themselves."
    //  ];
    case 16:
      return ["The best way to combat lies is with truth.", "Buddha"];
    case 17:
      return [
        "The best way to succeed is to believe that you can.",
        "Steven Covey"
      ];
    case 18:
      return ["The best way to feel blessed is to acknowledge your blessings."];
    case 19:
      return [
        "The best way to make the world a better place is to start with yourself."
      ];
    case 20:
      return [
        "If you don’t believe in yourself, no one else will.",
        "Oprah Winfrey"
      ];
    case 21:
      return [
        "If you want to achieve something, you must be willing to work hard.",
        "Dwight Eisenhower"
      ];
    case 22:
      return [
        "Everything is possible if you just believe in yourself.",
        "Steven Covey"
      ];
    case 23:
      return [
        "If you’re not trying, you’re already losing.",
        "George Bernard Shaw"
      ];
    case 24:
      return ["The only way to succeed is to try.", "John Stuart Mill"];
    case 25:
      return [
        "The best way to predict the future is to create it.",
        "Abraham Lincoln"
      ];
    case 26:
      return ["If you can’t imagine it, you can’t achieve it.", "Zig Ziglar"];
    case 27:
      return [
        "Life is what happens to you while you’re busy making other plans.",
        "John Lennon"
      ];
    case 28:
      return [
        "If you can’t make it happen, find someone who can.",
        "Albert Einstein"
      ];
    case 29:
      return [
        "The best way to start is to stop talking and start doing.",
        "Winston Churchill"
      ];
    case 30:
      return [
        "If you don’t like something, change it. If you can’t change it, change your attitude towards it.",
        "Milton H. Erickson"
      ];
    case 7: //31
      return [
        "The best way to overcome fear is to confront it.",
        "Albert Einstein"
      ];
    case 15: //32
      return [
        "If you want to be successful, you must be willing to fail.",
        "Tony Robbins"
      ];
    default:
      return [
        "The only way to do great work is to love what you do.",
        "Steve Jobs"
      ];
  }
}
