import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gif/flutter_gif.dart';

class MyGifWidget extends StatefulWidget {
  final File videoFile;

  const MyGifWidget({Key? key, required this.videoFile}) : super(key: key);

  @override
  _MyGifWidgetState createState() => _MyGifWidgetState();
}

class _MyGifWidgetState extends State<MyGifWidget>
    with TickerProviderStateMixin {
  late FlutterGifController controller;

  @override
  void initState() {
    super.initState();
    controller = FlutterGifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.repeat(
        min: 0,
        max: 50000,
        period: const Duration(milliseconds: 3000),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GifImage(
      controller: controller,
      image: FileImage(widget.videoFile),
    );
  }
}
