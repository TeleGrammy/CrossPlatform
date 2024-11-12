import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:telegrammy/cores/constants/app_colors.dart';

class StoryView extends StatefulWidget {
  const StoryView({super.key, required this.image, this.viewCount = 0});
  final File image;
  final int viewCount;
  final int duration = 7;
  @override
  State<StoryView> createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  double progress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startProgress() {
    const tickDuration = Duration(milliseconds: 100);
    int ticks = (widget.duration * 1000) ~/ tickDuration.inMilliseconds;
    int tickCount = 0;

    _timer = Timer.periodic(tickDuration, (timer) {
      if (tickCount >= ticks) {
        timer.cancel();
        context.pop(); // Close the story when it completes
      } else {
        setState(() {
          progress = tickCount / ticks;
        });
        tickCount++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              right: 20,
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            Positioned(
              top: 30,
              left: 10,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            Positioned(
              bottom: 30,
              left: 20,
              child: Row(
                children: [
                  Icon(Icons.remove_red_eye, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '${widget.viewCount} views',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
