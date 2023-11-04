import 'package:flutter/material.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CustomYoutubePlayer extends StatefulWidget {
  const CustomYoutubePlayer({
    super.key,
    required this.videoURL,
  });
  final String videoURL;

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.videoURL);
    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
        loop: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      // showVideoProgressIndicator: true,
      // progressColors: ProgressBarColors(
      //   handleColor: TColor.secondaryColor2,
      //   playedColor: TColor.secondaryColor2,
      //   backgroundColor: TColor.secondaryColor1,
      // ),
      onReady: (() => debugPrint('Ready')),
      bottomActions: [
        CurrentPosition(),
        ProgressBar(
          isExpanded: true,
          colors: ProgressBarColors(
            handleColor: TColor.secondaryColor2,
            playedColor: TColor.secondaryColor2,
            backgroundColor: TColor.secondaryColor1,
          ),
        ),
        PlaybackSpeedButton(
          icon: Image.asset(
            'assets/img/play_speed_controal.png',
            scale: 24,
            color: TColor.lightGray,
          ),
        ),
        // FullScreenButton(),//safearea와 화면고정 문제
      ],
    );
  }
}
