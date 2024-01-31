import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/screens/habits_heatmap_screen.dart';

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
        body: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  scrollDirection: Axis.vertical,
                  headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    SliverToBoxAdapter(
                      //headerSilverBuilder only accepts slivers
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 40),
                                  child: Text(
                                    "habits".tr(),
                                    style: TextStyle(
                                      fontSize: 35,
                                      fontFamily: 'PTSans',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                TabBar(
                                  labelColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  unselectedLabelColor:
                                      Theme.of(context).colorScheme.secondary,
                                  indicatorColor: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  tabs: [
                                    Tab(
                                      text: 'habits'.tr(),
                                    ),
                                    Tab(
                                      text: 'heatmap'.tr(),
                                    )
                                  ],
                                  controller: _tabController,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      const HabitsMeScreen(),
                      HabitsHeatmapScreen(),
                    ],
                  ),
                ))
            ////////////////////////

            ));
  }
}
