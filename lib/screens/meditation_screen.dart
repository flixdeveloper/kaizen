import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:kaizen/firebase_handle.dart';
import 'package:kaizen/rounded_base.dart';
import 'package:kaizen/screens/in_meditation_screen.dart';
import 'package:kaizen/volume_controller.dart';
import 'dart:ui' as ui;

AudioPlayer audioPlayer = AudioPlayer();
Duration duration = const Duration(minutes: 5, seconds: 0);
String startBell = "2";
String endBell = "2";
int song = 0;

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreen();
}

class _MeditationScreen extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 30, 50, 40),
            child: Text(
              "meditation".tr(),
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'PTSans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildMusic(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(45, 20, 45, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //pickTime
                GestureDetector(
                  onTap: () => {
                    pickTime(),
                    Feedback.forTap(context),
                  },
                  child: Rounded(
                      Row(
                        //navigate to next screen!!!
                        //Navigator.push(context, MaterialPageRoute(builder: (contetxt) => IconPickScreen(),),);
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('duration'.tr()),
                          const Spacer(),
                          Text(printDuration(duration)),
                          Image.asset('nextIcon'.tr(), scale: 3),
                          ///////////////////////////////////////
                          //CupertinoTimerPicker(
                          //  mode: CupertinoTimerPickerMode.hm,
                          //  initialTimerDuration: duration,
                          //  // This is called when the user changes the timer's
                          //  // duration.
                          //  onTimerDurationChanged: (Duration newDuration) {
                          //    setState(() => duration = newDuration);
                          //  },
                          //),
                          ////////////////////////////////////
                        ],
                      ),
                      15,
                      10),
                ),
                const SizedBox(height: 10),
                Rounded(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('starting_bell'.tr()),
                        const Spacer(),
                        buildDropdownBellStart(() => setState(() {})),
                      ],
                    ),
                    15,
                    10),
                const SizedBox(height: 10),
                Rounded(
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ending_bell'.tr()),
                        const Spacer(),
                        buildDropdownBellEnd(() => setState(() {})),
                      ],
                    ),
                    15,
                    10),
              ],
            ),
          ),
          const SizedBox(height: 50),
          //const Spacer(), //////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: Row(
              textDirection: ui.TextDirection.ltr,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    child: VolumeBar(player: audioPlayer),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveMeditation();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InMeditationScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.play_arrow),
                ),
                const Spacer()
              ],
            ),
          )
        ],
      ),
    )));
  }

  Widget buildDropdownBellStart(Function setState) {
    List<String> list = [
      'bell_outside'.tr(),
      'bell_struck'.tr(),
      'gong'.tr(),
      'zenbell'.tr()
    ];
    return DropdownButton<String>(
      value: list[int.parse(startBell)],
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        startBell = list.indexOf(value!).toString();
        setState();
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget buildDropdownBellEnd(Function setState) {
    List<String> list = [
      'bell_outside'.tr(),
      'bell_struck'.tr(),
      'gong'.tr(),
      'zenbell'.tr()
    ];
    return DropdownButton<String>(
      value: list[int.parse(endBell)],
      icon: Image.asset('nextIcon'.tr(), scale: 3),
      elevation: 6,
      onChanged: (String? value) {
        //update verb inside function?
        // This is called when the user selects an item.
        endBell = list.indexOf(value!).toString();
        setState();
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void pickTime() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => Container(
        height: 300,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close the modal
                  CupertinoButton(
                    child: Text('cancel'.tr()),
                    onPressed: () => Navigator.pop(context),
                  ),
                  // Save the duration and close the modal
                  CupertinoButton(
                    child: Text('done'.tr()),
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {});
                    },
                  ),
                ],
              ),
              // The timer picker widget
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: duration,
                  secondInterval: 5,
                  // This is called when the user changes the timer's
                  // duration.
                  onTimerDurationChanged: (Duration newDuration) {
                    duration = newDuration;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMusic(BuildContext context) {
    final List<String> imgList = [
      'autumn_sky.jpg',
      'just_relax.jpg',
      'peaceful_garden.jpg',
      'piano_moment.jpg',
      'nothing.jpg',
      'please_calm_my_mind.jpg',
    ];

    final List<String> imgNames = [
      'autumn_sky'.tr(),
      'just_relax'.tr(),
      'peaceful_garden'.tr(),
      'piano_moment'.tr(),
      'no_sound'.tr(),
      'calm_my_mind'.tr(),
    ];

    final List<Widget> imageSliders = imgNames
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                            'assets/images/${imgList[imgNames.indexOf(item)]}',
                            fit: BoxFit.cover,
                            width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();

    return Container(
      child: CarouselSlider(
        options: CarouselOptions(
          initialPage: song,
          onPageChanged: (index, reason) => song = index,
          autoPlay: false,
          aspectRatio: 2.0,
          enlargeCenterPage: true,
        ),
        items: imageSliders,
      ),
    );
  }
}

String printDuration(Duration duration) {
  String hours = "${duration.inHours}:";
  if (hours == "0:") hours = "";
  String twoDigits(int n) => n.toString().padLeft(2, "0");
  final String minutes;
  if (hours != "") {
    minutes = twoDigits(duration.inMinutes.remainder(60));
  } else {
    minutes = "${duration.inMinutes.remainder(60)}";
  }
  return "$hours$minutes:${twoDigits(duration.inSeconds.remainder(60))}";
}
