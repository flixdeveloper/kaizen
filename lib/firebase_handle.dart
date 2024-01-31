import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/goal.dart';
import 'package:kaizen/heat_object.dart';
import 'package:kaizen/screens/settings_screen.dart';
import 'package:kaizen/firebase_options.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/home_widget.dart';
import 'package:kaizen/note.dart';
import 'package:kaizen/screens/meditation_screen.dart';

Future<CollectionReference<Map<String, dynamic>>?> userFirePath() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;
  final userPath = "users/${user.uid}";
  final userRef = FirebaseFirestore.instance.collection(userPath);
  return userRef;
}

Future<void> initFirebase() async {
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {}
  return;
}

Future<void> deleteUserAccount() async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
  } on FirebaseAuthException catch (e) {
    if (e.code == "requires-recent-login") {
      await _reauthenticateAndDelete();
    } else {
      // Handle other Firebase exceptions
    }
  } catch (e) {
    // Handle general exception
  }
}

Future<void> _reauthenticateAndDelete() async {
  try {
    final providerData = FirebaseAuth.instance.currentUser?.providerData.first;

    if (AppleAuthProvider().providerId == providerData!.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(AppleAuthProvider());
    } else if (GoogleAuthProvider().providerId == providerData.providerId) {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithProvider(GoogleAuthProvider());
    }

    await FirebaseAuth.instance.currentUser?.delete();
  } catch (e) {
    // Handle exceptions
  }
}

void deleteEveryData() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  FirebaseFirestore.instance.collection("habits").doc(user.uid).delete();
  FirebaseFirestore.instance.collection("notes").doc(user.uid).delete();
  FirebaseFirestore.instance.collection("meditation").doc(user.uid).delete();
  FirebaseFirestore.instance.collection("settings").doc(user.uid).delete();
}

void saveHabit(List<Habit> habits) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  Heat.todayHeat = Heat.createTodayHeat();
  FirebaseFirestore.instance.collection("habits").doc(user.uid).set({
    'habits': habits.map((e) => e.toJson()).toList(),
    'heatmap': Heat.heat.map((e) => e.toJson()).toList(),
    'last_heat': Heat.todayHeat.toJson(),
  });
}

void saveNote(List<Note> notes) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance
      .collection("notes")
      .doc(user.uid)
      .set({'notes': notes.map((e) => e.toJson()).toList()});
}

void saveMiq(Note miq) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance
      .collection("miq")
      .doc(user.uid)
      .set({'miq': miq.toJson()});
}

void saveGoal(List<Goal> goals) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance
      .collection("goals")
      .doc(user.uid)
      .set({'goals': goals.map((e) => e.toJson()).toList()});
}

void saveMeditation() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance.collection("meditation").doc(user.uid).set({
    'volume': audioPlayer.volume,
    'duration': duration.inSeconds,
    'song': song,
    'startBell': startBell,
    'endBell': endBell,
  });
}

void initMeditation() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  var meditationData = await FirebaseFirestore.instance
      .collection("meditation")
      .doc(user.uid)
      .get();
  var data = meditationData.data();
  if (data == null || !data.containsKey("song")) return;
  audioPlayer.setVolume(data['volume']);
  duration = Duration(seconds: data["duration"]);
  startBell = bellToNum(data["startBell"]);
  endBell = bellToNum(data["endBell"]);
  song = data["song"];
}

String bellToNum(String freq) {
  int? num = int.tryParse(freq);
  if (num != null) return num.toString();
  switch (freq) {
    case 'bell_outside':
      return '0';
    case 'bell_struck':
      return '1';
    case 'gong':
      return '2';
    default:
      return '3';
  }
}

Future<List<Habit>> getHabits(BuildContext context) async {
  List<Habit> list = [];

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return list;
  var habitData =
      await FirebaseFirestore.instance.collection("habits").doc(user.uid).get();
  var data = habitData.data();
  if (data == null || !data.containsKey("habits")) return list;

  var habits = data["habits"].map((e) => Habit.fromJson(e)).toList();
  for (Habit habit in habits) {
    habit.resetHabit(context);
    list.add(habit);
  }
  if (data.containsKey("heatmap")) {
    Heat.heat = [];
    var objs = data["heatmap"].map((e) => Heat.fromJson(e)).toList();
    for (var obj in objs) {
      Heat.heat.add(obj);
    }
  }
  if (data.containsKey("last_heat")) {
    DateTime d = DateTime.now();
    final date = DateTime(d.year, d.month, d.day);

    final lastHeat = Heat.fromJson(data["last_heat"]);

    if (!lastHeat.date.isAtSameMomentAs(date) && lastHeat.did.isNotEmpty)
      Heat.heat.add(lastHeat);
  }
  Heat.todayHeat = Heat.createTodayHeat(givenHabits: list);
  return list;
}

Future<List<Goal>> getGoals() async {
  List<Goal> list = [];

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return list;
  var goalData =
      await FirebaseFirestore.instance.collection("goals").doc(user.uid).get();
  var data = goalData.data();
  if (data == null || !data.containsKey("goals")) return list;

  var goals = data["goals"].map((e) => Goal.fromJson(e)).toList();
  for (var goal in goals) {
    list.add(goal);
  }
  return list;
}

Future<List<Note>> getNotes() async {
  List<Note> list = [];

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return list;
  var notesData =
      await FirebaseFirestore.instance.collection("notes").doc(user.uid).get();
  var data = notesData.data();
  if (data == null || !data.containsKey("notes")) return list;

  var notes = data["notes"].map((e) => Note.fromJson(e)).toList();
  for (Note note in notes) {
    note.fixQuestions();
    list.add(note);
  }
  return list;
}

Future<Note> getMiq() async {
  final defaultMiq = Note('5', [
    "miq_1",
    "miq_2",
    "miq_3",
  ], [
    '',
    '',
    ''
  ]);
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return defaultMiq;

  var miqData =
      await FirebaseFirestore.instance.collection("miq").doc(user.uid).get();
  var data = miqData.data();
  if (data == null || !data.containsKey("miq")) return defaultMiq;

  return Note.fromJson(data["miq"]);
}

void saveSettings(bool is24, String firstDay, String darkMode) {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance.collection("settings").doc(user.uid).set({
    'is24': is24,
    'firstDay': firstDay,
    'darkMode': darkMode,
  });
}

Future<void> initSettings(BuildContext context) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  var settingsData = await FirebaseFirestore.instance
      .collection("settings")
      .doc(user.uid)
      .get();
  var data = settingsData.data();
  if (data == null || !data.containsKey("is24")) {
    SettingsScreen.is24 = MediaQuery.of(context).alwaysUse24HourFormat;
    SettingsScreen.firstDay =
        MaterialLocalizations.of(context).firstDayOfWeekIndex.toString();
    SettingsScreen.darkMode = '0';
    return;
  }
  SettingsScreen.is24 = data["is24"];
  SettingsScreen.firstDay = getFirstDayIndex(data["firstDay"]);
  SettingsScreen.darkMode = getDarkModeIndex(data["darkMode"]);
  return;
}

String getFirstDayIndex(String firstDay) {
  int? num = int.tryParse(firstDay);
  if (num != null) return num.toString();
  switch (firstDay) {
    case "Saturday":
      return '6';
    case "Monday":
      return '1';
    default:
      return '0';
  }
}

String getDarkModeIndex(String firstDay) {
  int? num = int.tryParse(firstDay);
  if (num != null) return num.toString();
  switch (firstDay) {
    case 'Light Mode':
      return '2';
    case 'Dark Mode':
      return '1';
    default:
      return '0';
  }
}

Future<List<HomeWidget>> getHomeWidgets() async {
  List<HomeWidget> list = [];
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return list;
  var HomeWidgetsJson =
      await FirebaseFirestore.instance.collection("home").get();

  for (var widget in HomeWidgetsJson.docs) {
    list.add(HomeWidget.fromJson(widget.data()));
  }
  return list.reversed.toList();
}
