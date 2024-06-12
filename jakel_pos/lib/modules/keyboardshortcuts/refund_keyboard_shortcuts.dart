import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/keyboard_shortcuts_utils.dart';

class RefundKeyboardShortcuts extends StatefulWidget {
  final Widget child;
  final Function onAction;

  const RefundKeyboardShortcuts({
    Key? key,
    required this.child,
    required this.onAction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<RefundKeyboardShortcuts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.keyR},
        onKeysPressed: () {
          MyLogUtils.logDebug(" Show Refund Via Keyboard shortcut");
          widget.onAction();
        },
        helpLabel: "Show Refund",
        child: widget.child);
  }
}
