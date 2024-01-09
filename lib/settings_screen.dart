import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  static int firstDayIndex() {
    switch (firstDay) {
      case "Saturday":
        return 6;
      case "Monday":
        return 1;
      default:
        return 0;
    }
  }

  static initDarkMode(BuildContext context) {
    switch (darkMode) {
      case 'Light Mode':
        AdaptiveTheme.of(context).setLight();
      case 'Dark Mode':
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
  var tmpIs24 = '12h';
  var tmpFirstDay = SettingsScreen.firstDay.substring(0);
  var tmpDarkMode = SettingsScreen.darkMode.substring(0);
  @override
  Widget build(BuildContext context) {
    if (SettingsScreen.is24) tmpIs24 = '24h';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
                        const Text('Time Format'),
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
                        const Text('First Day Of Week'),
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
                        const Text('Dark Mode'),
                        const Spacer(),
                        buildDropdownDarkMode(() => setState(() {})),
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
                    saveSettings(tmpIs24 == "24h", tmpFirstDay, tmpDarkMode);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Save Changes",
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
                    "Logout",
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
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                            "The account deletion process was either unsuccessful or only partially successful!"),
                      ));
                    }
                  },
                  child: Text(
                    "Delete Account",
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

  Widget buildDropdownFirstDay(Function setState) {
    List<String> list = ['Sunday', 'Monday', 'Saturday'];
    return DropdownButton<String>(
      value: tmpFirstDay,
      icon: Image.asset('assets/images/next.png', scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        tmpFirstDay = value!;
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
      icon: Image.asset('assets/images/next.png', scale: 3),
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

  Widget buildDropdownDarkMode(Function setState) {
    List<String> list = ['Default', 'Dark Mode', 'Light Mode'];
    return DropdownButton<String>(
      value: tmpDarkMode,
      icon: Image.asset('assets/images/next.png', scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        tmpDarkMode = value!;
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
        firstDayToString(MaterialLocalizations.of(context).firstDayOfWeekIndex);
    SettingsScreen.darkMode = 'Default';
    AdaptiveTheme.of(context).setSystem();
    audioPlayer = AudioPlayer();
    duration = const Duration(minutes: 5, seconds: 0);
    startBell = "Gong";
    endBell = "Gong";
    song = 0;
    habits = [];
    notes = [];
    homeWidgets = [];
    FlutterLocalNotificationsPlugin().cancelAll();
  }
}
