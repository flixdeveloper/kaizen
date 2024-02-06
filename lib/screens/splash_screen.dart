import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/main.dart';
import 'package:kaizen/screens/goals_screen.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/home_screen.dart';
import 'package:kaizen/screens/login_screen.dart';
import 'package:kaizen/screens/notes_screen.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool noTimer = false;
  bool didStart = false;
  late Timer timer;
  late Widget nextScreen;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    asyncInit();
  }

  Future<void> asyncInit() async {
    nextScreen = await getNext(context);
    if (noTimer) {
      replaceScreen();
    } else {
      timer = Timer(const Duration(seconds: 7), () => replaceScreen());
      didStart = true;
    }
  }

  Future<void> replaceScreen() async {
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
            noTimer = true;
            if (didStart) {
              replaceScreen();
              timer.cancel();
            }
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
                alignment: const Alignment(0.0, -0.22),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            '“'.tr(),
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
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
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
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            '”'.tr(),
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
                    padding: const EdgeInsets.fromLTRB(
                        0, 0, 0, 45), //add padding here
                    //change padding to be only from bottom?
                    child: Container(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: (noTimer)
                              ? LoadingAnimationWidget.twistingDots(
                                  leftDotColor: const Color(0xFF1A1A3F),
                                  rightDotColor: const Color(0xFFEA3799),
                                  size: 30,
                                )
                              : Text(
                                  'TAP TO DISMISS'.tr(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                )),
                      height: 70,
                      width: double.infinity,
                    )),
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
      miq = await getMiq();
      habits = await getHabits(context);
      goals = await getGoals();
      notes = await getNotes();
      homeWidgets = await getHomeWidgets();
      return const MyHomePage();
    }
  } catch (e) {}
  return const LoginScreen();
}

List<String> getSentence(int num) {
  switch (num) {
    case 1:
      return ["splash_1".tr(), "splash_2".tr()];
    case 2:
      return ["splash_3".tr()];
    case 3:
      return ["splash_4".tr(), "splash_5".tr()];
    case 4:
      return ["splash_6".tr(), "splash_7".tr()];
    case 5:
      return ["splash_8".tr()];
    case 6:
      return ["splash_9".tr()];
    case 7:
      return ["splash_10".tr(), "splash_11".tr()];
    case 8:
      return ["splash_12".tr(), "splash_13".tr()];
    case 9:
      return ["splash_51".tr()];
    case 10:
      return ["splash_14".tr(), "splash_11".tr()];
    case 11:
      return ["splash_16".tr(), "splash_17".tr()];
    case 12:
      return ["splash_18".tr(), "splash_19".tr()];
    case 13:
      return ["splash_20".tr(), "splash_7".tr()];
    case 14:
      return ["splash_22".tr(), "splash_7".tr()];
    case 15:
      return ["splash_52".tr(), "splash_23".tr()];
    case 16:
      return ["splash_24".tr(), "splash_17".tr()];
    case 17:
      return ["splash_26".tr(), "splash_7".tr()];
    case 18:
      return ["splash_28".tr()];
    case 19:
      return ["splash_29".tr()];
    case 20:
      return ["splash_53".tr(), "splash_5".tr()];
    case 21:
      return ["splash_31".tr(), "splash_32".tr()];
    case 22:
      return ["splash_33".tr(), "splash_7".tr()];
    case 23:
      return ["splash_35".tr(), "splash_36".tr()];
    case 24:
      return ["splash_37".tr(), "splash_38".tr()];
    case 25:
      return ["splash_54".tr()];
    case 26:
      return ["splash_39".tr(), "splash_40".tr()];
    case 27:
      return ["splash_41".tr(), "splash_42".tr()];
    case 28:
      return ["splash_43".tr(), "splash_11".tr()];
    case 29:
      return ["splash_45".tr(), "splash_46".tr()];
    case 30:
      return ["splash_47".tr(), "splash_48".tr()];
    default:
      return ["splash_49".tr(), "splash_50".tr()];
  }
}
