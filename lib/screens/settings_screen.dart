import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/rounded_base.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/home_screen.dart';
import 'package:kaizen/screens/login_screen.dart';
import 'package:kaizen/screens/meditation_screen.dart';
import 'package:kaizen/screens/notes_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  static late bool is24;
  static late String firstDay;
  static late String darkMode;

  static initDarkMode(BuildContext context) {
    switch (darkMode) {
      case '2':
        AdaptiveTheme.of(context).setLight();
      case '1':
        AdaptiveTheme.of(context).setDark();
      default:
        AdaptiveTheme.of(context).setSystem();
    }
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreen();
}

class _SettingsScreen extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  late var tmpLanguage = context.locale.toString();
  var tmpIs24 = SettingsScreen.is24 ? '24h' : '12h';
  var tmpFirstDay = SettingsScreen.firstDay.substring(0);
  var tmpDarkMode = SettingsScreen.darkMode.substring(0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding:
                const EdgeInsets.fromLTRB(80, 35, 80, 20), //add padding here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Rounded(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('time_format'.tr()),
                        const Spacer(),
                        buildDropdownTimeFormat(() => setState(() {})),
                      ],
                    ),
                    15,
                    10),
                const SizedBox(height: 10),
                Rounded(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('first_day'.tr()),
                        const Spacer(),
                        buildDropdownFirstDay(() => setState(() {})),
                      ],
                    ),
                    15,
                    10),
                const SizedBox(height: 10),
                Rounded(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('dark'.tr()),
                        const Spacer(),
                        buildDropdownDarkMode(() => setState(() {})),
                      ],
                    ),
                    15,
                    10),
                const SizedBox(height: 10),
                Rounded(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('language'.tr()),
                        const Spacer(),
                        buildDropdownLanguage(() => setState(() {})),
                      ],
                    ),
                    15,
                    10),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded edge
                    ),
                  ),
                  onPressed: () {
                    SettingsScreen.darkMode = tmpDarkMode;
                    SettingsScreen.firstDay = tmpFirstDay;
                    SettingsScreen.is24 = tmpIs24 == "24h";
                    SettingsScreen.initDarkMode(context);
                    context.setLocale(Locale(tmpLanguage));
                    saveSettings(tmpIs24 == "24h", tmpFirstDay, tmpDarkMode);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "save".tr(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 250, 250, 250),
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 60),
                Divider(),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded edge
                    ),
                  ),
                  onPressed: () {
                    deleteDetails();

                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  child: Text(
                    "out".tr(),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded edge
                    ),
                  ),
                  onPressed: () {
                    showDeleteDialog(context);
                  },
                  child: Text(
                    //TODO: popup are you sure
                    "delete_account".tr(),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 250, 250, 250),
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showCupertinoDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: Text('confirm_text'.tr()),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () {
                  try {
                    deleteEveryData();
                    deleteDetails();

                    deleteUserAccount();

                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false,
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("fail_delete".tr())));
                  }
                },
                isDefaultAction: true,
                isDestructiveAction: true,
                child: Text('yes'.tr()),
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                isDefaultAction: false,
                isDestructiveAction: false,
                child: Text('no'.tr()),
              )
            ],
          );
        });
  }

  String firstDayToString(String firstDay) {
    switch (firstDay) {
      case "6":
        return 'saturday'.tr();
      case "1":
        return 'monday'.tr();
      default:
        return 'sunday'.tr();
    }
  }

  String firstDayToIndex(String firstDay) {
    if (firstDay == 'saturday'.tr()) return '6';
    if (firstDay == 'monday'.tr()) return '1';
    return '0';
  }

  Widget buildDropdownFirstDay(Function setState) {
    List<String> list = ['sunday'.tr(), 'monday'.tr(), 'saturday'.tr()];
    return DropdownButton<String>(
      value: firstDayToString(tmpFirstDay),
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        tmpFirstDay = firstDayToIndex(value!);
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

  Widget buildDropdownTimeFormat(Function setState) {
    List<String> list = ['12h', '24h'];
    return DropdownButton<String>(
      value: tmpIs24,
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        tmpIs24 = value!;
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

  String darkModeToString(String firstDay) {
    switch (firstDay) {
      case "0":
        return 'default'.tr();
      case "1":
        return 'dark'.tr();
      default:
        return 'light'.tr();
    }
  }

  String darkModeToIndex(String firstDay) {
    if (firstDay == 'default'.tr()) return '0';
    if (firstDay == 'dark'.tr()) return '1';
    return '2';
  }

  Widget buildDropdownDarkMode(Function setState) {
    List<String> list = ['default'.tr(), 'dark'.tr(), 'light'.tr()];
    return DropdownButton<String>(
      value: darkModeToString(tmpDarkMode),
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        tmpDarkMode = darkModeToIndex(value!);
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

  Widget buildDropdownLanguage(Function setState) {
    List<String> list = ['en', 'he'];
    return DropdownButton<String>(
      value: tmpLanguage,
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        tmpLanguage = value!;
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

  void deleteDetails() {
    SettingsScreen.is24 = MediaQuery.of(context).alwaysUse24HourFormat;
    SettingsScreen.firstDay =
        MaterialLocalizations.of(context).firstDayOfWeekIndex.toString();
    SettingsScreen.darkMode = '0';
    AdaptiveTheme.of(context).setSystem();
    audioPlayer = AudioPlayer();
    duration = const Duration(minutes: 5, seconds: 0);
    startBell = '2';
    endBell = '2';
    song = 0;
    habits = [];
    notes = [];
    homeWidgets = [];
    FlutterLocalNotificationsPlugin().cancelAll();
  }

  getFirstDay(int day) {
    switch (day) {
      case 6:
        return "saturday".tr();
      case 1:
        return "monday".tr();
      default:
        return "sunday".tr();
    }
  }
}
