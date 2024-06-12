import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/keyboard_shortcuts_utils.dart';

class GoBackKeyboardShortcut extends StatefulWidget {
  final Widget child;
  final Function onAction;

  const GoBackKeyboardShortcut({
    Key? key,
    required this.child,
    required this.onAction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<GoBackKeyboardShortcut> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.escape},
        onKeysPressed: () {
          widget.onAction();
        },
        helpLabel: "Go back to previous screen",
        child: widget.child);
  }
}
