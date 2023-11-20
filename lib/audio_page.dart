import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/audio_player_handler.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:kaizen/home_widget.dart';

import 'package:kaizen/volume_controller.dart';

class AudioPlayer extends StatefulWidget {
  final HomeWidget widget;

  const AudioPlayer(
    this.widget,
  ) : super(key: null);

  @override
  State<StatefulWidget> createState() {
    return _AudioPlayerState();
  }
}

class _AudioPlayerState extends State<AudioPlayer> {
  late final VolumeBar volumeBar;

  @override
  void initState() {
    super.initState();
    getAudioManager().start(widget.widget);
    volumeBar = VolumeBar(player: getAudioManager().getAudioPlayer());
  }

  @override
  void dispose() {
    getAudioManager().stop();
    volumeBar.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: 7 / 5,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  imageUrl: widget.widget.background,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(widget.widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Visibility(
              visible: widget.widget.subTitle != null,
              child: Text(
                widget.widget.subTitle ?? "",
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 15),
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: getAudioManager().progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: getAudioManager().seek,
                );
              },
            ),
            const SizedBox(height: 5),
            buildRow()
            //ValueListenableBuilder<ButtonState>(
            //  valueListenable: getAudioManager().buttonNotifier,
            //  builder: (_, value, __) {
            //    switch (value) {
            //      case ButtonState.loading:
            //        return Container(
            //          margin: const EdgeInsets.all(8.0),
            //          width: 32.0,
            //          height: 32.0,
            //          child: const CircularProgressIndicator(),
            //        );
            //      case ButtonState.paused:
            //        return IconButton(
            //          icon: const Icon(Icons.play_arrow),
            //          iconSize: 32.0,
            //          onPressed: getAudioManager().play,
            //        );
            //      case ButtonState.playing:
            //        return IconButton(
            //          icon: const Icon(Icons.pause),
            //          iconSize: 32.0,
            //          onPressed: getAudioManager().pause,
            //        );
            //    }
            //  },
            //),
          ],
        ),
      ),
    );
  }

  Widget buildRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Opens volume slider dialog
        //IconButton(
        //  icon: const Icon(Icons.volume_up),
        //  iconSize: 25.0,
        //  onPressed: () {
        //    showSliderDialog(
        //      context: context,
        //      title: "Adjust volume",
        //      divisions: 10,
        //      min: 0.0,
        //      max: 1.0,
        //      value: getAudioManager().getAudioPlayer().volume,
        //      stream: getAudioManager().getAudioPlayer().volumeStream,
        //      onChanged: getAudioManager().getAudioPlayer().setVolume,
        //    );
        //  },
        //),
        volumeBar,
        /////////////////////////////////////
        IconButton(
          icon: const Icon(Icons.replay_10),
          iconSize: 25.0,
          onPressed: () {
            getAudioManager().rewind();
          },
        ),

        /// This StreamBuilder rebuilds whenever the player state changes, which
        /// includes the playing/paused state and also the
        /// loading/buffering/ready state. Depending on the state we show the
        /// appropriate button or loading indicator.
        ValueListenableBuilder<ButtonState>(
          valueListenable: getAudioManager().buttonNotifier,
          builder: (_, value, __) {
            switch (value) {
              case ButtonState.loading:
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 50.0,
                  height: 50.0,
                  child: const CircularProgressIndicator(),
                );
              case ButtonState.paused:
                return IconButton(
                  icon: const Icon(Icons.play_arrow),
                  iconSize: 50.0,
                  onPressed: getAudioManager().play,
                );
              case ButtonState.playing:
                return IconButton(
                  icon: const Icon(Icons.pause),
                  iconSize: 50.0,
                  onPressed: getAudioManager().pause,
                );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.forward_10),
          iconSize: 25.0,
          onPressed: () {
            getAudioManager().fastForward();
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: getAudioManager().getAudioPlayer().speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                maxLines: 1,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            iconSize: 25.0,
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 6,
                min: 0.5,
                max: 2,
                value: getAudioManager().getAudioPlayer().speed,
                stream: getAudioManager().getAudioPlayer().speedStream,
                onChanged: getAudioManager().getAudioPlayer().setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => SizedBox(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix' 'x',
                  style: const TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
