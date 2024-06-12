import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/keyboard_shortcuts_utils.dart';

class HomeKeyboardShortCutWidget extends StatefulWidget {
  final Widget child;

  const HomeKeyboardShortCutWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<HomeKeyboardShortCutWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
        keysToPress: {
          LogicalKeyboardKey.controlLeft,
          LogicalKeyboardKey.digit1
        },
        onKeysPressed: () {
          MyLogUtils.logDebug("Go to Menu 1");
        },
        helpLabel: "Go to Menu 1(For Test)",
        child: widget.child);
  }
}
