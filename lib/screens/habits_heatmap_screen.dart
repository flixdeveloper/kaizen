import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kaizen/add_habit.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/habit.dart';
import 'package:kaizen/heat_object.dart';
import 'package:kaizen/notification_service.dart';
import 'package:kaizen/rounded_base.dart';
import 'dart:ui' as ui;

late DateTime startDate;
late Map<DateTime, int> dataSets;

class HabitsHeatmapScreen extends StatefulWidget {
  const HabitsHeatmapScreen({super.key});

  @override
  State<HabitsHeatmapScreen> createState() => _HabitsHeatmapScreen();
}

class _HabitsHeatmapScreen extends State<HabitsHeatmapScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 10, 12, 80),
        child: HeatMapCalendar(
          defaultColor: Theme.of(context).colorScheme.background,
          flexible: true,
          showColorTip: false,
          colorMode: ColorMode.color,
          textColor: Theme.of(context).colorScheme.primary,
          size: 30,
          datasets: Heat.heatmap(),
          colorsets: {
            1: Colors.green.shade100,
            38: Colors.green.shade300,
            66: Colors.green.shade600,
            100: Colors.green.shade900,
          },
          onClick: (value) {
            final clicked = Heat.relevantHeat(value);
            if (clicked != null)
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(clicked.toPrint())));
          },
        ),
      ),
    ));
  }
}
