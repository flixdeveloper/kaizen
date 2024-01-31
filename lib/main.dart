import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kaizen/audio_player_handler.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/note.dart';
import 'package:kaizen/notification_service.dart';
import 'package:kaizen/screens/goals_screen.dart';
import 'package:kaizen/screens/habits_me_screen.dart';
import 'package:kaizen/screens/habits_screen.dart';
import 'package:kaizen/screens/home_screen.dart';
import 'package:kaizen/screens/notes_screen.dart';
import 'package:kaizen/screens/settings_screen.dart';
import 'package:kaizen/screens/splash_screen.dart';
import 'package:kaizen/screens/meditation_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kaizen/theme/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kaizen/view_note.dart';
import 'package:timezone/data/latest.dart' as tz;

late Note miq;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await EasyLocalization.ensureInitialized();
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

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('he')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: MyApp(savedThemeMode: savedThemeMode)));
  //runApp(
  //  DevicePreview(
  //    enabled: !kReleaseMode,
  //    builder: (context) => MyApp(),
  //  ),
  //);
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: lightMode,
      dark: darkMode,
      initial: savedThemeMode ?? AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'kaizen',
        theme: theme,
        darkTheme: darkTheme,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: const SplashScreen(),
        navigatorKey: NotificationService.navigatorKey, // set property
      ),
    );
    //return MaterialApp(
    //  //useInheritedMediaQuery: true, //
    //  //locale: DevicePreview.locale(context), //
    //  //builder: DevicePreview.appBuilder, //
    //  title: 'kaizen',
    //  theme: lightMode,
    //  darkTheme: darkMode,
    //  home: const SplashScreen(),
    //  navigatorKey: NotificationService.navigatorKey, // set property
    //);
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
    const HabitsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    //for (Habit habit in habits) {
    //  habit.resetHabit(context);
    //}
  }

  buildMIQ() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (contetxt) => buildUpdateNote(context, miq, isMiq: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
    var drawer = Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            child: Text(
              'KaiZen',
              style: TextStyle(
                fontSize: 50,
                fontFamily: 'kaushanScript',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.workspace_premium),
              title: Text(
                'goals'.tr(),
                style: TextStyle(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contetxt) => const GoalsScreen(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.psychology_alt),
              title: Text(
                'MIQ',
                style: TextStyle(),
              ),
              onTap: () => buildMIQ(),
            ),
          ),
          Padding(
            padding: tilePadding,
            child: ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'settings'.tr(),
                style: TextStyle(),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (contetxt) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],

        ///////////////////////////////////////////////////////////
        //)
        ////////////////////////////////////////////////////////////
        //buildMIQ()
        //Navigator.push(
        //  context,
        //  MaterialPageRoute(
        //    builder: (contetxt) => const GoalsScreen(),
        //  ),
        //)
      ),
    );

    return Scaffold(
        drawer: drawer,
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
                tabs: [
                  GButton(
                    icon: Icons.home,
                    text: 'home'.tr(),
                  ),
                  GButton(
                    icon: Icons.sticky_note_2,
                    text: 'notes'.tr(),
                  ),
                  GButton(
                    icon: Icons.self_improvement, //MyFlutterApp.meditation,
                    text: 'meditation'.tr(),
                  ),
                  GButton(
                    icon: Icons.check_circle,
                    text: 'habits'.tr(),
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
