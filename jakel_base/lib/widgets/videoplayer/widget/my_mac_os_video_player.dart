import 'package:flutter/material.dart';

import '../../../utils/my_assets.dart';

class MyMacOsVideoPlayer extends StatefulWidget {
  const MyMacOsVideoPlayer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyMacOsVideoPlayerState();
  }
}

class _MyMacOsVideoPlayerState extends State<MyMacOsVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ariyaniBanner),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
