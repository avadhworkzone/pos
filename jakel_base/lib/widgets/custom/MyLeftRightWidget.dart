import 'package:flutter/material.dart';

class MyLeftRightWidget extends StatelessWidget {
  final String lText, rText;
  final TextStyle? rStyle, lStyle;
  final Color? color;

  const MyLeftRightWidget(
      {Key? key,
      required this.lText,
      required this.rText,
      this.color,
      this.rStyle,
      this.lStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            lText,
            style: lStyle ?? Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              rText,
              style: rStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        )
      ],
    );
  }
}
