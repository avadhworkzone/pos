import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/shift_close_keyboard_shortcut.dart';
import 'package:jakel_base/utils/keyboard_shortcuts_utils.dart';

class HomeScreenKeyboardShortcut extends StatefulWidget {
  final Widget child;
  final Function onHome;
  final Function onShiftClose;
  final Function onMembers;

  const HomeScreenKeyboardShortcut({
    Key? key,
    required this.child,
    required this.onHome,
    required this.onShiftClose,
    required this.onMembers,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<HomeScreenKeyboardShortcut> {
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
          widget.onHome();
        },
        helpLabel: "Go to Home",
        child: getShiftClose(widget.child));
  }

  Widget getShiftClose(Widget child) {
    return KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.f4},
        onKeysPressed: () {
          widget.onShiftClose();
        },
        helpLabel: "Go to shift close",
        child: membersWidget(child));
  }

  Widget membersWidget(Widget child) {
    return KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyK},
        onKeysPressed: () {
          widget.onMembers();
        },
        helpLabel: "Show all members",
        child: child);
  }
}
