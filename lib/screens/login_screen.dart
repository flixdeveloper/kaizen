import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/main.dart';
import 'package:kaizen/notification_service.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/home_screen.dart';
import 'package:kaizen/screens/notes_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUser(LoginData data) async {
    return Future.delayed(loginTime).then((_) {
      // TODO: Add sign up logic here
      return signIn(data);
    });
  }

  Future<String?> signIn(LoginData loginData) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "${loginData.name}@abc.com", password: loginData.password);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }

    initMeditation();
    habits = await getHabits();
    notes = await getNotes();
    homeWidgets = await getHomeWidgets();
    for (var habit in habits) {
      NotificationService().setNotifications(habit);
    }

    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    return Future.delayed(loginTime).then((_) {
      // TODO: Add sign up logic here
      return signUp(data);
    });
  }

  Future<String?> signUp(SignupData data) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "${data.name}@abc.com", password: data.password ?? "");
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'KaiZen',
      //logo: AssetImage('assets/images/kaizen.png'),
      userType: LoginUserType.name,
      userValidator: userValidator,
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const MyHomePage(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      hideForgotPasswordButton: true,
    );
  }
}

String? userValidator(String? str) {
  if (str == null) return null;
  if (str.length < 4) return "Username is too short!";
  if (str.contains("@")) return "Username can't contain - @";
  if (str.length > 10) return "Username is too long!";
  return null;
}

void displayMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(message),
    ),
  );
}
