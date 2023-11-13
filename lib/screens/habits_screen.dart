import 'package:flutter/material.dart';

import 'package:kaizen/screens/habits_me_screen.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreen();
}

class _HabitsScreen extends State<HabitsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(50, 80, 50, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Habits",
                    style: TextStyle(
                      fontSize: 35,
                      fontFamily: 'PTSans',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TabBar(
                    padding: const EdgeInsets.all(20),
                    tabs: const [
                      Tab(
                        text: 'Me',
                      ),
                      Tab(
                        text: 'Friends',
                      )
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                ],
              )),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              const HabitsMeScreen(),
              Container(
                child: const Center(child: Text('people')),
              ),
            ],
          ),
        ),
        //make tabbar go on top under
      ],
    ));
  }
}
