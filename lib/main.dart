//import 'package:device_preview/device_preview.dart'; //
//import 'package:flutter/foundation.dart'; //
//import 'package:audio_service/audio_service.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaizen/audio_player_handler.dart';
//import 'package:kaizen/audio_player_handler.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/notification_service.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/home_screen.dart';
import 'package:kaizen/screens/notes_screen.dart';
import 'package:kaizen/screens/splash_screen.dart';
import 'package:kaizen/screens/meditation_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kaizen/theme/theme.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await initFirebase();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  final service = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.kaizen.channel.audio',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  setAudioManager(service);

  //await JustAudioBackground.init(
  //  androidNotificationChannelId: 'com.kaizen.channel.audio',
  //  androidNotificationChannelName: 'Audio playback',
  //  androidNotificationOngoing: true,
  //);

  runApp(const MyApp());
  //runApp(
  //  DevicePreview(
  //    enabled: !kReleaseMode,
  //    builder: (context) => MyApp(),
  //  ),
  //);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //useInheritedMediaQuery: true, //
      //locale: DevicePreview.locale(context), //
      //builder: DevicePreview.appBuilder, //
      title: 'kaizen',
      theme: lightMode,
      darkTheme: darkMode,
      home: const SplashScreen(),
      navigatorKey: NotificationService.navigatorKey, // set property
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPage = 0;

  final _pageOptions = [
    const HomeScreen(),
    const NotesScreen(),
    const MeditationScreen(),
    const HabitsMeScreen(),
  ];

  @override
  void initState() {
    super.initState();
    for (Habit habit in habits) {
      habit.resetHabit(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _pageOptions[selectedPage],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: GNav(
                rippleColor: Theme.of(context).colorScheme.tertiary,
                hoverColor: Theme.of(context).colorScheme.background,
                gap: 8,
                activeColor: Theme.of(context).colorScheme.onSurface,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Theme.of(context).colorScheme.background,
                color: Theme.of(context).colorScheme.onSurface,
                tabs: const [
                  GButton(
                    icon: Icons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.sticky_note_2,
                    text: 'Notes',
                  ),
                  GButton(
                    icon: Icons.self_improvement, //MyFlutterApp.meditation,
                    text: 'Meditation',
                  ),
                  GButton(
                    icon: Icons.check_circle,
                    text: 'Habits',
                  ),
                ],
                selectedIndex: selectedPage,
                onTabChange: (index) {
                  setState(() {
                    selectedPage = index;
                  });
                },
              ),
            ),
          ),
        ));
  }
}
