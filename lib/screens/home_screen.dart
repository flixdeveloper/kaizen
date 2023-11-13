import 'package:flutter/material.dart';

import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/home_widget.dart';

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
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxScrolled) => [
        SliverAppBar(
          expandedHeight: 135,
          toolbarHeight: 110,
          title: Align(
              alignment: Alignment.bottomCenter,
              child: Column(children: [
                Text(
                  "Good ${timeDay()}!",
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
    );
  }
}

String timeDay() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Morning';
  }
  if (hour < 17) {
    return 'Afternoon';
  }
  return 'Evening';
}
