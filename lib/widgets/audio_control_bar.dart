import 'package:Iqra/provider/general_provider.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';

class AudioControlBar extends StatefulWidget {
  final AudioPlayer audioPlayer;
  final Duration duration;
  final Duration position;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final String surahName;
  final int verseNumber; // Dynamic verse number updated in real-time
  final bool isLoading;
  final String flag;

  const AudioControlBar(
      {super.key,
      required this.audioPlayer,
      required this.duration,
      required this.position,
      required this.onPause,
      required this.onResume,
      required this.onSeekBackward,
      required this.onSeekForward,
      required this.surahName,
      required this.verseNumber,
      required this.isLoading,
      required this.flag});

  @override
  State<AudioControlBar> createState() => _AudioControlBarState();
}

class _AudioControlBarState extends State<AudioControlBar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GeneralProvider>(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Position: ${widget.position.inSeconds}'),
          Text('Duration: ${widget.duration.inSeconds}'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.surahName,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Verse: ${widget.verseNumber}', // Real-time verse update
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Slider(
            value: widget.position.inSeconds.toDouble(),
            min: 0.0,
            max: widget.duration.inSeconds.toDouble(),
            onChanged: (value) {
              widget.audioPlayer.seek(Duration(seconds: value.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: widget.onSeekBackward,
              ),
              widget.isLoading
                  ? const CircularProgressIndicator()
                  : IconButton(
                      icon: Icon(widget.audioPlayer.state == PlayerState.playing
                          ? Icons.pause
                          : Icons.play_arrow),
                      onPressed: widget.audioPlayer.state == PlayerState.playing
                          ? widget.onPause
                          : widget.onResume,
                    ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: widget.onSeekForward,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  widget.audioPlayer.stop();

                  if (widget.flag == 'surah') {
                    provider.manageSurahPlayer(false);
                  } else {
                    provider.manageVersePlayer(false);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
