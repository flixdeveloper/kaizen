import 'dart:async';

import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:kaizen/screens/meditation_screen.dart';
import 'package:kaizen/volume_controller.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../audio_service.dart';

class InMeditationScreen extends StatefulWidget {
  var timerControlller = CountdownController(autoStart: true);
  bool isBellPaused = false;
  bool isSoundPaused = false;
  var buttonNotifier = ValueNotifier<ButtonState>(ButtonState.playing);
  late PausableTimer timer;
  late AudioPlayer musicPlayer;
  late AudioPlayer bellPlayer;
  late VolumeBar volumeBar;

  InMeditationScreen({super.key});

  @override
  State<InMeditationScreen> createState() => _InMeditationScreen();

  void playAudio() {
    musicPlayer.play();
  }

  void playBell() {
    bellPlayer.play();
  }

  void pauseAudio() {
    musicPlayer.pause();
  }

  void pauseBell() {
    bellPlayer.pause();
  }
}

class _InMeditationScreen extends State<InMeditationScreen>
    with SingleTickerProviderStateMixin {
  var visible = true;
  bool finishedAnimation = false;

  @override
  void initState() {
    super.initState();
    finishedAnimation = false;
    widget.musicPlayer = AudioPlayer()..setLoopMode(LoopMode.one);
    widget.musicPlayer.setVolume(audioPlayer.volume);
    widget.volumeBar = VolumeBar(player: widget.musicPlayer, isWhite: true);
    widget.bellPlayer = AudioPlayer();
    widget.bellPlayer.setVolume(audioPlayer.volume);
    widget.isBellPaused = false;
    widget.isSoundPaused = false;
    widget.buttonNotifier = ValueNotifier<ButtonState>(ButtonState.playing);
    String songName = getSongName();
    if (songName != "") widget.musicPlayer.setAsset('assets/music/$songName');
    widget.bellPlayer.setAsset('assets/music/${translateBell(startBell)}');
    startMeditation();
  }

  String getSongName() {
    switch (song) {
      case 0:
        return "autumn_sky.mp3";
      case 1:
        return "just_relax.mp3";
      case 2:
        return "peaceful_garden.mp3";
      case 3:
        return "piano_moment.mp3";
      case 4:
        return "";
      default:
        return "please_calm_my_mind.mp3";
    }
  }

  String translateBell(String bell) {
    switch (bell) {
      case 'Bell outside':
        return "bell-outside.wav";
      case 'Bell struck':
        return "bowl_struck.wav";
      case 'Gong':
        return "gong.wav";
      default:
        return "zenbell.mp3";
    }
  }

  @override
  void dispose() {
    widget.timer.cancel();
    widget.musicPlayer.dispose();
    widget.bellPlayer.dispose();
    widget.volumeBar.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {
              if (!(widget.isBellPaused || widget.isSoundPaused))
                setState(() {
                  finishedAnimation = false;
                  visible = !visible;
                })
            },
        child: Scaffold(
            backgroundColor: Colors.black,
            body: TweenAnimationBuilder(
              onEnd: () => {finishedAnimation = true},
              tween: Tween<double>(begin: 1, end: visible ? 1 : 0),
              duration: const Duration(milliseconds: 500),
              builder: (context, opacity, _) {
                return Opacity(
                  opacity: opacity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: 80),
                          child: Text(
                            "Meditation",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Countdown(
                          seconds: duration.inSeconds,
                          build: (BuildContext context, double time) => Text(
                            printDuration(Duration(seconds: time.round())),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontFamily: 'PTSans',
                            ),
                          ),
                          interval: const Duration(milliseconds: 100),
                          onFinished: () {
                            finishMeditation();
                          },
                          controller: widget.timerControlller,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ValueListenableBuilder<ButtonState>(
                                valueListenable: widget.buttonNotifier,
                                builder: (_, value, __) {
                                  if (value == ButtonState.paused) {
                                    return widget.volumeBar;
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              const SizedBox(width: 15),
                              if (visible || !finishedAnimation)
                                ValueListenableBuilder<ButtonState>(
                                  valueListenable: widget.buttonNotifier,
                                  builder: (_, value, __) {
                                    if (value == ButtonState.paused) {
                                      return IconButton(
                                        icon: const Icon(Icons.play_arrow),
                                        color: Colors.white,
                                        iconSize: 35.0,
                                        onPressed: playClicked,
                                      );
                                    } else {
                                      return IconButton(
                                        icon: const Icon(Icons.pause),
                                        color: Colors.white,
                                        iconSize: 35.0,
                                        onPressed: pauseClicked,
                                      );
                                    }
                                  },
                                ),
                              const SizedBox(width: 15),
                              ValueListenableBuilder<ButtonState>(
                                valueListenable: widget.buttonNotifier,
                                builder: (_, value, __) {
                                  if (value == ButtonState.paused) {
                                    return IconButton(
                                      iconSize: 35,
                                      color: Colors.white,
                                      icon: const Icon(Icons.stop),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )));
  }

  Future<void> startMeditation() async {
    widget.bellPlayer.play();

    // Create a timer that runs after 7 seconds
    widget.timer = PausableTimer(const Duration(seconds: 7), () {
      widget.musicPlayer.play();
    });
    widget.timer.start();
  }

  void finishMeditation() {
    widget.musicPlayer.stop();
    widget.bellPlayer
      ..setAsset('assets/music/${translateBell(endBell)}')
      ..play();
    Timer(const Duration(seconds: 7), () {
      Navigator.pop(context);
    });
  }

  void pauseClicked() {
    if (visible) {
      if (widget.musicPlayer.playing) {
        widget.isSoundPaused = true;
        widget.pauseAudio();
      } else if (widget.timer.isActive) {
        widget.timer.pause();
      }
      if (widget.bellPlayer.playing) {
        widget.isBellPaused = true;
        widget.pauseBell();
      }
      widget.timerControlller.pause();
      widget.buttonNotifier.value = ButtonState.paused;
    }
  }

  void playClicked() {
    if (widget.isSoundPaused) {
      widget.playAudio();
      widget.isSoundPaused = false;
    } else if (widget.timer.isPaused) {
      widget.timer.start();
    }
    if (widget.isBellPaused) {
      widget.playBell();
      widget.isBellPaused = false;
    }
    widget.timerControlller.resume();
    widget.buttonNotifier.value = ButtonState.playing;
  }
}
