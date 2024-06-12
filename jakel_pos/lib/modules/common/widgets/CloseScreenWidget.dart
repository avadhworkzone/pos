import 'package:flutter/material.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/keyboardshortcuts/go_back_keyboard_shortcut.dart';

class CloseScreenWidget extends StatefulWidget {
  const CloseScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CloseScreenState();
  }
}

class _CloseScreenState extends State<CloseScreenWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoBackKeyboardShortcut(
        onAction: () {
          Navigator.pop(context);
        },
        child: MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            }));
  }
}
