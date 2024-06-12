import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

class KeyboardFocusController {
  late void Function() requestFocus;
}

class KeyboardWidget extends StatefulWidget {
  final bool? requestFocus;
  final Function? onEnter;
  final Function? onEsc;
  final Function? onUp;
  final Function? onDown;
  final Function? onLeft;
  final Function? onRight;
  final Function? onShift;
  final Function? onNumber;
  final Function? onInsert;
  final Function? onEnd;
  final Function? onTab;
  final Function? onAdd;
  final Function? onSubtract;
  final Function? onDelete;
  final Function? onDecimal;
  final Function? onPeriod;
  final KeyboardFocusController? keyboardFocusController;
  final Widget child;

  const KeyboardWidget(
      {Key? key,
      this.onEnter,
      this.onEsc,
      required this.child,
      this.onUp,
      this.onDown,
      this.onLeft,
      this.onRight,
      this.onShift,
      this.onNumber,
      this.keyboardFocusController,
      this.onInsert,
      this.onEnd,
      this.onTab,
      this.onAdd,
      this.onSubtract,
      this.onDelete,
      this.onDecimal,
      this.onPeriod,
      this.requestFocus})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _KeyboardState(keyboardFocusController);
  }
}

class _KeyboardState extends State<KeyboardWidget> {
  Map<LogicalKeySet, Intent> _shortcutMap = {};
  Map<Type, Action<Intent>> _actionMap = {};

  final FocusNode focusNode = FocusNode();

  _KeyboardState(KeyboardFocusController? keyboardFocusController) {
    if (keyboardFocusController != null) {
      keyboardFocusController.requestFocus = _requestFocus;
    }
  }

  void _actionHandler(_ShowSecretMessageIntent intent) {
    MyLogUtils.logDebug("_actionHandler : ${intent.type}");

    switch (intent.type) {
      case _SecretMessageType.ENTER:
        if (widget.onEnter != null) widget.onEnter!();
        break;
      case _SecretMessageType.NUMPAD_ENTER:
        if (widget.onEnter != null) widget.onEnter!();
        break;
      case _SecretMessageType.TAB:
        if (widget.onTab != null) widget.onTab!();
        break;
      case _SecretMessageType.ESC:
        if (widget.onEsc != null) widget.onEsc!();
        break;
      case _SecretMessageType.UP:
        if (widget.onUp != null) widget.onUp!();
        break;
      case _SecretMessageType.DOWN:
        if (widget.onDown != null) widget.onDown!();
        break;
      case _SecretMessageType.LEFT:
        if (widget.onLeft != null) widget.onLeft!();
        break;
      case _SecretMessageType.RIGHT:
        if (widget.onRight != null) widget.onRight!();
        break;
      case _SecretMessageType.SHIFT:
        if (widget.onShift != null) widget.onShift!();
        break;
      case _SecretMessageType.NUMBER_1:
        if (widget.onNumber != null) widget.onNumber!(1);
        break;
      case _SecretMessageType.NUMBER_2:
        if (widget.onNumber != null) widget.onNumber!(2);
        break;
      case _SecretMessageType.NUMBER_3:
        if (widget.onNumber != null) widget.onNumber!(3);
        break;
      case _SecretMessageType.NUMBER_4:
        if (widget.onNumber != null) widget.onNumber!(4);
        break;
      case _SecretMessageType.NUMBER_5:
        if (widget.onNumber != null) widget.onNumber!(5);
        break;
      case _SecretMessageType.NUMBER_6:
        if (widget.onNumber != null) widget.onNumber!(6);
        break;
      case _SecretMessageType.NUMBER_7:
        if (widget.onNumber != null) widget.onNumber!(7);
        break;
      case _SecretMessageType.NUMBER_8:
        if (widget.onNumber != null) widget.onNumber!(8);
        break;
      case _SecretMessageType.NUMBER_9:
        if (widget.onNumber != null) widget.onNumber!(9);
        break;
      case _SecretMessageType.NUMBER_0:
        if (widget.onNumber != null) widget.onNumber!(0);
        break;
      case _SecretMessageType.INSERT:
        if (widget.onInsert != null) widget.onInsert!();
        break;
      case _SecretMessageType.END:
        if (widget.onEnd != null) widget.onEnd!();
        break;
      case _SecretMessageType.MINUS:
        if (widget.onSubtract != null) widget.onSubtract!();
        break;
      case _SecretMessageType.ADD:
        if (widget.onSubtract != null) widget.onAdd!();
        break;
      case _SecretMessageType.DELETE:
        if (widget.onDelete != null) widget.onDelete!();
        break;
      case _SecretMessageType.BACKSPACE:
        if (widget.onDelete != null) widget.onDelete!();
        break;
      case _SecretMessageType.DECIMAL:
        if (widget.onDecimal != null) widget.onDecimal!();
        break;
      case _SecretMessageType.PERIOD:
        if (widget.onPeriod != null) widget.onPeriod!();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _shortcutMap = <LogicalKeySet, Intent>{
      LogicalKeySet(LogicalKeyboardKey.enter):
          const _ShowSecretMessageIntent.enter(),
      LogicalKeySet(LogicalKeyboardKey.escape):
          const _ShowSecretMessageIntent.esc(),
      LogicalKeySet(LogicalKeyboardKey.arrowUp):
          const _ShowSecretMessageIntent.up(),
      LogicalKeySet(LogicalKeyboardKey.arrowDown):
          const _ShowSecretMessageIntent.down(),
      LogicalKeySet(LogicalKeyboardKey.arrowLeft):
          const _ShowSecretMessageIntent.left(),
      LogicalKeySet(LogicalKeyboardKey.arrowRight):
          const _ShowSecretMessageIntent.right(),
      LogicalKeySet(LogicalKeyboardKey.tab):
          const _ShowSecretMessageIntent.tab(),
      LogicalKeySet(LogicalKeyboardKey.shift):
          const _ShowSecretMessageIntent.shift(),
      LogicalKeySet(LogicalKeyboardKey.numpad0):
          const _ShowSecretMessageIntent.NUMBER_0(),
      LogicalKeySet(LogicalKeyboardKey.numpad1):
          const _ShowSecretMessageIntent.number_1(),
      LogicalKeySet(LogicalKeyboardKey.numpad2):
          const _ShowSecretMessageIntent.number_2(),
      LogicalKeySet(LogicalKeyboardKey.numpad3):
          const _ShowSecretMessageIntent.number_3(),
      LogicalKeySet(LogicalKeyboardKey.numpad4):
          const _ShowSecretMessageIntent.number_4(),
      LogicalKeySet(LogicalKeyboardKey.numpad5):
          const _ShowSecretMessageIntent.number_5(),
      LogicalKeySet(LogicalKeyboardKey.numpad6):
          const _ShowSecretMessageIntent.NUMBER_6(),
      LogicalKeySet(LogicalKeyboardKey.numpad7):
          const _ShowSecretMessageIntent.NUMBER_7(),
      LogicalKeySet(LogicalKeyboardKey.numpad8):
          const _ShowSecretMessageIntent.NUMBER_8(),
      LogicalKeySet(LogicalKeyboardKey.numpad9):
          const _ShowSecretMessageIntent.NUMBER_9(),
      LogicalKeySet(LogicalKeyboardKey.digit0):
          const _ShowSecretMessageIntent.NUMBER_0(),
      LogicalKeySet(LogicalKeyboardKey.digit1):
          const _ShowSecretMessageIntent.number_1(),
      LogicalKeySet(LogicalKeyboardKey.digit2):
          const _ShowSecretMessageIntent.number_2(),
      LogicalKeySet(LogicalKeyboardKey.digit3):
          const _ShowSecretMessageIntent.number_3(),
      LogicalKeySet(LogicalKeyboardKey.digit4):
          const _ShowSecretMessageIntent.number_4(),
      LogicalKeySet(LogicalKeyboardKey.digit5):
          const _ShowSecretMessageIntent.number_5(),
      LogicalKeySet(LogicalKeyboardKey.digit6):
          const _ShowSecretMessageIntent.NUMBER_6(),
      LogicalKeySet(LogicalKeyboardKey.digit7):
          const _ShowSecretMessageIntent.NUMBER_7(),
      LogicalKeySet(LogicalKeyboardKey.digit8):
          const _ShowSecretMessageIntent.NUMBER_8(),
      LogicalKeySet(LogicalKeyboardKey.digit9):
          const _ShowSecretMessageIntent.NUMBER_9(),
      LogicalKeySet(LogicalKeyboardKey.insert):
          const _ShowSecretMessageIntent.INSERT(),
      LogicalKeySet(LogicalKeyboardKey.end):
          const _ShowSecretMessageIntent.END(),
      LogicalKeySet(LogicalKeyboardKey.numpadEnter):
          const _ShowSecretMessageIntent.NUMPAD_ENTER(),
      LogicalKeySet(LogicalKeyboardKey.numpadAdd):
          const _ShowSecretMessageIntent.ADD(),
      LogicalKeySet(LogicalKeyboardKey.numpadSubtract):
          const _ShowSecretMessageIntent.MINUS(),
      LogicalKeySet(LogicalKeyboardKey.home):
          const _ShowSecretMessageIntent.HOME(),
      LogicalKeySet(LogicalKeyboardKey.delete):
          const _ShowSecretMessageIntent.DELETE(),
      LogicalKeySet(LogicalKeyboardKey.backspace):
          const _ShowSecretMessageIntent.BACKSPACE(),
      LogicalKeySet(LogicalKeyboardKey.numpadDecimal):
          const _ShowSecretMessageIntent.DECIMAL(),
      LogicalKeySet(LogicalKeyboardKey.period):
          const _ShowSecretMessageIntent.PERIOD(),
    };
    _actionMap = <Type, Action<Intent>>{
      _ShowSecretMessageIntent: CallbackAction<_ShowSecretMessageIntent>(
        onInvoke: _actionHandler,
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.requestFocus != null && widget.requestFocus!) {
      _requestFocus();
    }
    return FocusableActionDetector(
        autofocus: true,
        focusNode: focusNode,
        actions: _actionMap,
        shortcuts: _shortcutMap,
        child: GestureDetector(
          onTap: () {
            focusNode.requestFocus();
          },
          child: widget.child,
        ));
  }

  void _requestFocus() {
    focusNode.requestFocus();
  }
}

class _ShowSecretMessageIntent extends Intent {
  const _ShowSecretMessageIntent({required this.type});

  const _ShowSecretMessageIntent.enter() : type = _SecretMessageType.ENTER;

  const _ShowSecretMessageIntent.esc() : type = _SecretMessageType.ESC;

  const _ShowSecretMessageIntent.up() : type = _SecretMessageType.UP;

  const _ShowSecretMessageIntent.down() : type = _SecretMessageType.DOWN;

  const _ShowSecretMessageIntent.left() : type = _SecretMessageType.LEFT;

  const _ShowSecretMessageIntent.right() : type = _SecretMessageType.RIGHT;

  const _ShowSecretMessageIntent.tab() : type = _SecretMessageType.TAB;

  const _ShowSecretMessageIntent.shift() : type = _SecretMessageType.SHIFT;

  const _ShowSecretMessageIntent.number_1()
      : type = _SecretMessageType.NUMBER_1;

  const _ShowSecretMessageIntent.number_2()
      : type = _SecretMessageType.NUMBER_2;

  const _ShowSecretMessageIntent.number_3()
      : type = _SecretMessageType.NUMBER_3;

  const _ShowSecretMessageIntent.number_4()
      : type = _SecretMessageType.NUMBER_4;

  const _ShowSecretMessageIntent.number_5()
      : type = _SecretMessageType.NUMBER_5;

  const _ShowSecretMessageIntent.NUMBER_6()
      : type = _SecretMessageType.NUMBER_6;

  const _ShowSecretMessageIntent.NUMBER_7()
      : type = _SecretMessageType.NUMBER_7;

  const _ShowSecretMessageIntent.NUMBER_8()
      : type = _SecretMessageType.NUMBER_8;

  const _ShowSecretMessageIntent.NUMBER_9()
      : type = _SecretMessageType.NUMBER_9;

  const _ShowSecretMessageIntent.NUMBER_0()
      : type = _SecretMessageType.NUMBER_0;

  const _ShowSecretMessageIntent.INSERT() : type = _SecretMessageType.INSERT;

  const _ShowSecretMessageIntent.END() : type = _SecretMessageType.END;

  const _ShowSecretMessageIntent.ADD() : type = _SecretMessageType.ADD;

  const _ShowSecretMessageIntent.MINUS() : type = _SecretMessageType.MINUS;

  const _ShowSecretMessageIntent.HOME() : type = _SecretMessageType.HOME;

  const _ShowSecretMessageIntent.NUMPAD_ENTER()
      : type = _SecretMessageType.NUMPAD_ENTER;

  const _ShowSecretMessageIntent.DELETE() : type = _SecretMessageType.DELETE;

  const _ShowSecretMessageIntent.BACKSPACE()
      : type = _SecretMessageType.BACKSPACE;

  const _ShowSecretMessageIntent.DECIMAL() : type = _SecretMessageType.DECIMAL;

  const _ShowSecretMessageIntent.PERIOD() : type = _SecretMessageType.PERIOD;

  final _SecretMessageType type;
}

enum _SecretMessageType {
  ENTER,
  ESC,
  UP,
  DOWN,
  LEFT,
  RIGHT,
  TAB,
  SHIFT,
  NUMBER_1,
  NUMBER_2,
  NUMBER_3,
  NUMBER_4,
  NUMBER_5,
  NUMBER_6,
  NUMBER_7,
  NUMBER_8,
  NUMBER_9,
  NUMBER_0,
  INSERT,
  END,
  ADD,
  MINUS,
  HOME,
  NUMPAD_ENTER,
  DELETE,
  DECIMAL,
  PERIOD,
  BACKSPACE
}
