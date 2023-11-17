import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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

void saveHabit(List<Habit> habits) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance
      .collection("habits")
      .doc(user.uid)
      .set({'habits': habits.map((e) => e.toJson()).toList()});
}

void saveNote(List<Note> notes) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return;
  FirebaseFirestore.instance
      .collection("notes")
      .doc(user.uid)
      .set({'notes': notes.map((e) => e.toJson()).toList()});
}

void saveMeditation() async {
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
  if (user == null) return null;
  var meditationData = await FirebaseFirestore.instance
      .collection("meditation")
      .doc(user.uid)
      .get();
  var data = meditationData.data();
  if (data == null || !data.containsKey("song")) return;
  audioPlayer.setVolume(data['volume']);
  duration = Duration(seconds: data["duration"]);
  startBell = data["startBell"];
  endBell = data["endBell"];
  song = data["song"];
}

Future<List<Habit>> getHabits() async {
  List<Habit> list = [];

  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return list;
  var habitData =
      await FirebaseFirestore.instance.collection("habits").doc(user.uid).get();
  var data = habitData.data();
  if (data == null || !data.containsKey("habits")) return list;

  var habits = data["habits"].map((e) => Habit.fromJson(e)).toList();
  for (var habit in habits) {
    list.add(habit);
  }
  return list;
  //{'habits': habits.map((e) => e.toJson()).toList()}

  //saveHabit(list); ????????????????????????????????????????????????????????
  //   .then((QuerySnapshot querySnapshot) {
  // querySnapshot.docs.forEach((habit) {
  //   Habit.fromJson(habit.data());
  // });
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
  for (var note in notes) {
    list.add(note);
  }
  return list;
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
  return list;
}
