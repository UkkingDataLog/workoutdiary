// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A widget to display playback speed changing button.
class MuteControllerButton extends StatefulWidget {
  /// Overrides the default [YoutubePlayerController].
  final YoutubePlayerController? controller;

  /// Defines icon for the button.
  final Widget? icon;

  /// Creates [MuteControllerButton] widget.
  const MuteControllerButton({
    this.controller,
    this.icon,
  });

  @override
  _MuteControllerButtonState createState() => _MuteControllerButtonState();
}

class _MuteControllerButtonState extends State<MuteControllerButton> {
  late YoutubePlayerController _controller;
  bool noMute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = YoutubePlayerController.of(context);
    if (controller == null) {
      assert(
        widget.controller != null,
        '\n\nNo controller could be found in the provided context.\n\n'
        'Try passing the controller explicitly.',
      );
      _controller = widget.controller!;
    } else {
      _controller = controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: (noMute == false)
          ? const Icon(
              Icons.volume_off,
              size: 24,
              color: Colors.white,
            )
          : const Icon(
              Icons.volume_down,
              size: 24,
              color: Colors.white,
            ),
      tooltip: 'PlayBack Rate',
      onPressed: () {
        if (noMute == false) {
          _controller.unMute();
          noMute = true;
        } else {
          _controller.mute();
          noMute = false;
        }
        setState(() {});
      },
    );
  }
}
