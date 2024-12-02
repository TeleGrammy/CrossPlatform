import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final AudioPlayer audioPlayer;
  const AudioPlayerWidget({Key? key, required this.audioUrl,required this.audioPlayer}) : super(key: key);

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  bool isPlaying = false;


  void togglePlayPause() async {
    if (isPlaying) {
      await widget.audioPlayer.pause();
    } else {
      await widget.audioPlayer.play(UrlSource(widget.audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('audio_player_row'),
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          key: const Key('play_pause_button'),
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: togglePlayPause,
        ),
        Text(
          isPlaying ? 'Playing...' : 'Paused',
          key: const Key('play_status_text'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.audioPlayer.dispose();
    super.dispose();
  }
}
