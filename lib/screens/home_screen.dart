import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/note.dart';
import 'package:kaizen/screens/goals_screen.dart';
import 'package:kaizen/screens/settings_screen.dart';

import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/home_widget.dart';
import 'package:kaizen/view_note.dart';

late List<HomeWidget> homeWidgets;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreen();
}

//https://pub.dev/packages/firebase_messaging

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = AdaptiveTheme.of(context).brightness == Brightness.dark;

    return Scaffold(
        body: Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        Positioned.fill(
            child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            SliverAppBar(
              foregroundColor: Colors.white,
              expandedHeight: 135,
              toolbarHeight: 110,
              title: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(children: [
                    Text(
                      timeDay(),
                      style: const TextStyle(
                        fontSize: 35,
                        fontFamily: 'PTSans',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'KaiZen',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'kaushanScript',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //const SizedBox(height: 1),
                  ])),
              flexibleSpace: const ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(150),
                  ),
                  child: Image(
                    image: AssetImage('assets/images/app_bar_background.jpg'),
                    fit: BoxFit.cover,
                  )),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(150),
                ),
              ),
            ),
          ],
          body: RefreshIndicator(
              onRefresh: () async {
                final widgets = await getHomeWidgets();
                setState(() {
                  homeWidgets = widgets;
                });
              },
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 55, bottom: 30),
                itemBuilder: (BuildContext context, int index) {
                  return homeWidgets[index].getWidget(context);
                },
                itemCount: homeWidgets.length,
              )),
        )),
        if (!isDarkMode)
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.04)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.7, 0.95],
                  )),
                  height: MediaQuery.of(context).viewPadding.top)),
        Align(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: EdgeInsets.fromLTRB(17, 65, 17, 0),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  iconSize: 15,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            )),
      ],
    ));
  }
}

String timeDay() {
  var hour = DateTime.now().hour;
  if (hour > 5 && hour < 12) {
    return tr('good_morning');
  }
  if (hour < 17) {
    return tr('good_afternoon');
  }
  return tr('good_evening');
}
