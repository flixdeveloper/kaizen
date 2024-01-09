import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

/*
 * PlayerBar is a widget that contains the player controls.
 *
 */

// ignore: must_be_immutable
class VolumeBar extends StatefulWidget {
  Function clear = () {};
  final AudioPlayer player;
  final bool isWhite;
  // ignore: prefer_const_constructors_in_immutables
  VolumeBar({super.key, required this.player, this.isWhite = false});

  @override
  State<VolumeBar> createState() => _PlayerBarState();
}

class _PlayerBarState extends State<VolumeBar> with TickerProviderStateMixin {
  bool _showVolumeBox = false;
  OverlayEntry? volumeBoxOverlayEntry;
  // Animation controller for Overlays
  // it responsible for showing/hiding the Overlays with one animation
  late AnimationController _animationController;
  late Animation<double>
      _animation; //change the animation so the position change is smaller?
  @override
  void initState() {
    super.initState();
    widget.clear = clear;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = _animationController.drive(
      CurveTween(
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showVolumeBox() {
    volumeBoxOverlayEntry?.remove();
    var viewPortSize = MediaQuery.of(context).size;

    RenderBox box = context.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    volumeBoxOverlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      hideVolumeBox();
                    });
                  },
                  child: Container(
                    color: Colors.black.withOpacity(0.1 * _animation.value),
                  ),
                ),
              ),
              Positioned(
                bottom: (viewPortSize.height - position.dy + 7 - 80) +
                    (80 * _animation.value),
                left: position.dx,
                width: box.size.width,
                height:
                    (190 - box.size.width) * _animation.value + box.size.width,
                child: Transform.scale(
                  scale: _animation.value,
                  child: Opacity(
                    opacity: _animation.value,
                    child: Material(
                      color: Theme.of(context).colorScheme.background,
                      elevation: 10,
                      borderRadius: BorderRadius.circular(100),
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: RotatedBox(
                              quarterTurns: 3,
                              child: PlayerVolume(
                                player: widget.player,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
    Overlay.of(context).insert(volumeBoxOverlayEntry!);
    _animationController.forward();
    _showVolumeBox = true;
  }

  void hideVolumeBox() async {
    await _animationController.reverse();
    clear();
  }

  void clear() {
    volumeBoxOverlayEntry?.remove();
    volumeBoxOverlayEntry = null;
    _showVolumeBox = false;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: widget.isWhite
          ? Colors.white
          : Theme.of(context).colorScheme.onSurface,
      onPressed: () {
        if (_showVolumeBox) {
          hideVolumeBox();
        } else {
          showVolumeBox();
        }
      },

      /// icon depends on the current volume
      /// if volume is 0, the icon is volume_off
      /// if volume is between 0 and 0.5, the icon is volume_down
      /// if volume is between 0.5 and 1, the icon is volume_up
      icon: StreamBuilder<double>(
        stream: widget.player.volumeStream, //streams.volume,
        builder: (context, snapshot) {
          return Icon(
            widget.player.volume == 0
                ? Icons.volume_off
                : widget.player.volume < 0.5
                    ? Icons.volume_down
                    : Icons.volume_up,
          );
        },
      ),
    );
  }
}

/// the [PlayerVolume] widget is used to control the volume of the player.
/// it contains a vertical slider to control the volume.
class PlayerVolume extends StatefulWidget {
  final AudioPlayer player;
  const PlayerVolume({super.key, required this.player});

  @override
  State<PlayerVolume> createState() => _PlayerVolumeState();
}

class _PlayerVolumeState extends State<PlayerVolume> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      stream: widget.player.volumeStream,
      builder: (context, snapshot) {
        return Slider(
          min: 0,
          max: 1,
          label: '${(widget.player.volume * 100.0).toStringAsFixed(0)}%',
          value: snapshot.data ?? widget.player.volume,
          onChanged: (double value) {
            widget.player.setVolume(value);
          },
        );
      },
    );
  }
}
