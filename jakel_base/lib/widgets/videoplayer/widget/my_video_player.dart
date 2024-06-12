import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:io' show File, Platform;

import 'package:jakel_base/widgets/videoplayer/widget/my_mac_os_video_player.dart';
import 'package:jakel_base/widgets/videoplayer/widget/my_windows_video_player.dart';

import '../../../utils/my_assets.dart';
import '../MyVideoPlayerViewModel.dart';

class MyVideoPlayer extends StatefulWidget {
  final String? fileName;

  const MyVideoPlayer({Key? key, required this.fileName}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyVideoPlayerState();
  }
}

class _MyVideoPlayerState extends State<MyVideoPlayer> {
  final viewModel = MyVideoPlayerViewModel();
  File? videoFile;

  @override
  Widget build(BuildContext context) {
    log("video_player  file : ${widget.fileName}");

    if (widget.fileName != null) {
      videoFile = File(widget.fileName!);
    }
    return getRootWidget();
  }

  Widget getRootWidget() {
    if (videoFile == null || !(videoFile!.existsSync())) {
      return Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ariyaniBanner),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    if (Platform.isWindows) {
      print("video_player  MyWindowsVideoPlayer ");
      return MyWindowsVideoPlayer(videoFile: videoFile!);
    }

    if (Platform.isMacOS) {
      return const MyMacOsVideoPlayer();
    }
    return const Center(
      child: Text("Not Supported"),
    );
  }
}
