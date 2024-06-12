import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jakel_base/utils/my_date_utils.dart';

class MyClockWidget extends StatefulWidget {
  const MyClockWidget({Key? key}) : super(key: key);

  @override
  _MyClockWidgetState createState() => _MyClockWidgetState();
}

class _MyClockWidgetState extends State<MyClockWidget> {
  String _timeString = "";

  @override
  void initState() {
    _timeString =
        readableDateVeryBig(DateTime.now().toLocal().millisecondsSinceEpoch) ??
            '';
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString.toUpperCase(),
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          color: Theme.of(context).primaryColor.withOpacity(0.8)),
    );
  }

  void _getCurrentTime() {
    setState(() {
      _timeString = readableDateVeryBig(
              DateTime.now().toLocal().millisecondsSinceEpoch) ??
          '';
    });
  }
}
