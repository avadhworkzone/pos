import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

// import 'package:flutter_meedu_videoplayer/init_meedu_player.dart';
// import 'package:flutter_meedu_videoplayer/meedu_player.dart';

import '../MyVideoPlayerViewModel.dart';

// import 'package:dart_vlc/dart_vlc.dart';
// import 'package:video_player_win/video_player_win.dart';

class MyWindowsVideoPlayer extends StatefulWidget {
  final File videoFile;

  const MyWindowsVideoPlayer({Key? key, required this.videoFile})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyWindowsVideoPlayerState();
  }
}

class _MyWindowsVideoPlayerState extends State<MyWindowsVideoPlayer> {
  final viewModel = MyVideoPlayerViewModel();

  // final _meeduPlayerController =
  //     MeeduPlayerController(controlsStyle: ControlsStyle.primary);

  StreamSubscription? _playerEventSubs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
  }

  @override
  void dispose() {
    _playerEventSubs?.cancel();
    //_meeduPlayerController.dispose();
    super.dispose();
  }

  _init() {
    // _meeduPlayerController.setDataSource(
    //   DataSource(
    //     type: DataSourceType.network,
    //     source:
    //         "https://movietrailers.apple.com/movies/paramount/the-spongebob-movie-sponge-on-the-run/the-spongebob-movie-sponge-on-the-run-big-game_h720p.mov",
    //   ),
    //   autoplay: true,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Text("Technical issue."),
          // child: MeeduVideoPlayer(
          //   controller: _meeduPlayerController,
          // ),
        ),
      ),
    );
  }
}
