import 'package:flutter/widgets.dart';

enum MyTextType { HEADER }

class HeaderTextWidget extends StatelessWidget {
  final String text;
  final MyTextType? type;
  final Color? color;

  const HeaderTextWidget({super.key,
    required this.text,
    this.type = MyTextType.HEADER,
    this.color = const Color(0xFFFFFFFF)});

  @override
  Widget build(BuildContext context) {
    //If multiple platform comes , add if else & update here
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 20),
    );
  }
}
