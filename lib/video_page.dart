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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    controller = PodPlayerController(
      playVideoFrom: (widget.isMp4)
          ? PlayVideoFrom.network(widget.url)
          : PlayVideoFrom.youtube(widget.url),
      podPlayerConfig: const PodPlayerConfig(
        videoQualityPriority: [720, 360],
        autoPlay: true,
      ),
    )..initialise();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    controller.dispose();
    super.dispose();
  }

  bool _isRtl() {
    final Locale locale = WidgetsBinding.instance.platformDispatcher.locale;
    final langs = [
      'ar', // Arabic
      'fa', // Farsi
      'he', // Hebrew
      'ps', // Pashto
      'ur', // Urdu
    ];
    for (int i = 0; i < langs.length; i++) {
      final lang = langs[i];
      if (locale.toString().contains(lang)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Directionality(
            textDirection: (_isRtl()) ? TextDirection.rtl : TextDirection.ltr,
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
            ),
          ),
        ));
  }
}
