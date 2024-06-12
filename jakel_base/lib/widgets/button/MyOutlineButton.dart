import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../theme/colors/my_colors.dart';

class MyOutlineButton extends StatelessWidget {
  final String text;
  final Function onClick;
  final MaterialStateProperty<Color?>? backgroundColor;

  const MyOutlineButton({Key? key,
    required this.text,
    required this.onClick,
    this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(backgroundColor: backgroundColor),
      onPressed: () {
        onClick();
      },
      child: Text(tr(text),
          style: TextStyle(color: getWhiteColor(context), fontSize: 13)),
    );
  }
}
