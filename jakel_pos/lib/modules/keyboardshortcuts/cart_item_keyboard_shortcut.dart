import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/keyboard_shortcuts_utils.dart';

class CartItemKeyboardShortcut extends StatefulWidget {
  final Widget child;
  final Function onAddPromoter;
  final Function onPriceOverride;
  final Function onFoc;

  const CartItemKeyboardShortcut({
    Key? key,
    required this.child,
    required this.onAddPromoter,
    required this.onPriceOverride,
    required this.onFoc,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState();
  }
}

class _KeyboardState extends State<CartItemKeyboardShortcut> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return promoterDialogWidget(priceOverride(widget.child));
  }

  Widget promoterDialogWidget(Widget child) {
    return KeyBoardShortcuts(
        key: widget.key,
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyP},
        onKeysPressed: () {
          MyLogUtils.logDebug(" Show Promoter Dialog ");
          widget.onAddPromoter();
        },
        helpLabel: "Show add promoter pop up",
        child: child);
  }

  Widget priceOverride(Widget child) {
    return KeyBoardShortcuts(
        keysToPress: {LogicalKeyboardKey.controlLeft, LogicalKeyboardKey.keyR},
        onKeysPressed: () {
          widget.onPriceOverride();
        },
        helpLabel: "Show Override",
        child: KeyBoardShortcuts(
            keysToPress: {
              LogicalKeyboardKey.controlLeft,
              LogicalKeyboardKey.keyG
            },
            onKeysPressed: () {
              widget.onPriceOverride();
            },
            helpLabel: "Show Group Discount",
            child: KeyBoardShortcuts(
                keysToPress: {
                  LogicalKeyboardKey.controlLeft,
                  LogicalKeyboardKey.keyE
                },
                onKeysPressed: () {
                  widget.onPriceOverride();
                },
                helpLabel: "Show Line Discount",
                child: KeyBoardShortcuts(
                    keysToPress: {
                      LogicalKeyboardKey.controlLeft,
                      LogicalKeyboardKey.keyO
                    },
                    onKeysPressed: () {
                      widget.onFoc();
                    },
                    helpLabel: "FOC",
                    child: child))));
  }
}
