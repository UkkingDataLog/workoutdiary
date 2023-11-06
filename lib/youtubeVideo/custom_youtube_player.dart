import 'package:flutter/material.dart';
import 'package:workoutdiary/common/colo_extension.dart';
import 'package:workoutdiary/youtubeVideo/youtubemute.dart';
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
        mute: true,
        autoPlay: true,
        loop: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noMute = (_controller.value.volume ?? 0) > 0;
    return Stack(
      children: [
        YoutubePlayer(
          controller: _controller,

          // showVideoProgressIndicator: true,
          // progressColors: ProgressBarColors(
          //   handleColor: TColor.secondaryColor2,
          //   playedColor: TColor.secondaryColor2,
          //   backgroundColor: TColor.secondaryColor1,
          // ),

          onReady: (() {
            _controller.addListener(() {});
          }),
          // topActions: <Widget>[
          //   const SizedBox(
          //     width: 8.0,
          //     height: 28,
          //   ),
          //   Expanded(
          //     child: Text(
          //       _controller.metadata.title,
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 18.0,
          //       ),
          //       overflow: TextOverflow.ellipsis,
          //       maxLines: 1,
          //     ),
          //   ),
          // ],
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

            RemainingDuration(),
            // 음악 높낮이 버튼 조작 필요
            MuteControllerButton(),
            PlaybackSpeedButton(
              icon: Image.asset(
                'assets/img/play_speed_controal.png',
                scale: 24,
                color: TColor.lightGray,
              ),
            ),
            // FullScreenButton(), //safearea와 화면고정 문제
          ],
        ),
      ],
    );
  }
}
