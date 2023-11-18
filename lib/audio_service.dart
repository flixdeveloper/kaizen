import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file/src/interface/file.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kaizen/audio_player_handler.dart';
import 'package:kaizen/home_widget.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AudioManager {
  final HomeWidget widget;
  late AudioPlayer _audioPlayer;

  AudioPlayer getAudioPlayer() {
    return _audioPlayer;
  }

  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );
  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  AudioManager(this.widget) {
    _init();
  }

  Future<Uri> findUri(String imageUrl) async {
    final cache = DefaultCacheManager(); // Gives a Singleton instance
    final file = await cache.getSingleFile(imageUrl);
    return file.uri;
  }

  void _init() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setUrl(widget.details);

    final mediaItem = await MediaItem(
      id: '1',
      album: (widget.subTitle == null) ? widget.subTitle : widget.title,
      title: (widget.subTitle == null) ? widget.title : widget.subTitle!,
      artUri: await findUri(widget.background),
    );

    //await AudioService.init(
    //  builder: () => AudioPlayerHandler(), //_audioPlayer, mediaItem),
    //  config: const AudioServiceConfig(
    //    androidNotificationChannelId: 'com.kaizen.channel.audio',
    //    androidNotificationChannelName: 'Audio playback',
    //    androidNotificationOngoing: true,
    //  ),
    //);

    _audioPlayer.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        buttonNotifier.value = ButtonState.paused;
      } else if (processingState != ProcessingState.completed) {
        buttonNotifier.value = ButtonState.playing;
      } else {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.pause();
      }
    });

    _audioPlayer.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });

    _audioPlayer.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _audioPlayer.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });
  }

  void replay() async {
    await _audioPlayer
        .seek(Duration(seconds: _audioPlayer.position.inSeconds - 10));
  }

  void forward() async {
    await _audioPlayer
        .seek(Duration(seconds: _audioPlayer.position.inSeconds + 10));
  }

  void play() {
    _audioPlayer.play();
  }

  void pause() {
    _audioPlayer.pause();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

//class ProgressBarState {
//  ProgressBarState({
//    required this.current,
//    required this.buffered,
//    required this.total,
//  });
//  final Duration current;
//  final Duration buffered;
//  final Duration total;
//}
//
//enum ButtonState { paused, playing, loading }
