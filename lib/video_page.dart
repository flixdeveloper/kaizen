import 'package:flutter/services.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter/material.dart';

class VideoPage extends StatefulWidget {
  final bool isMp4;
  final String url;

  const VideoPage(
    this.isMp4,
    this.url,
  ) : super(key: null);

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late final PodPlayerController controller;
  @override
  void initState() {
    super.initState();
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    controller = PodPlayerController(
      playVideoFrom: (widget.isMp4)
          ? PlayVideoFrom.network(widget.url)
          : PlayVideoFrom.youtube(widget.url),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [720, 360],
        autoPlay: true,
      ),
    )..initialise();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: PodVideoPlayer(
            controller: controller,
            podPlayerLabels: const PodPlayerLabels(
              play: "PLAY",
              pause: "PAUSE",
              error: "ERROR WHILE TRYING TO PLAY VIDEO",
              exitFullScreen: "EXIT FULL SCREEN",
              fullscreen: "FULL SCREEN",
              loopVideo: "LOOP VIDEO",
              mute: "MUTE",
              playbackSpeed: "PLAYBACK SPEED",
              settings: "SETTINGS",
              unmute: "UNMUTE",
              optionEnabled: "YES",
              optionDisabled: "NO",
              quality: "QUALITY",
            ),
            onToggleFullScreen: fullScreenToggle,
          ),
        ),
      ),
    );
  }

  Future<void> fullScreenToggle(bool isFullScreen) async {
    if (!isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: SystemUiOverlay.values);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    }
  }
}
