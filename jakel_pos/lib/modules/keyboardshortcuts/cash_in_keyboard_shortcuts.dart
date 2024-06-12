import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/keyboard_shortcuts_utils.dart';

class CashInKeyboardShortcuts extends StatefulWidget {
  final Widget child;
  final Function onAction;

  const CashInKeyboardShortcuts({
    Key? key,
    required this.child,
    required this.onAction,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<CashInKeyboardShortcuts> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyI},
        onKeysPressed: () {
          MyLogUtils.logDebug(" Show Cash In Via Keyboard shortcut");
          widget.onAction();
        },
        helpLabel: "Show Cash In",
        child: widget.child);
  }
}
