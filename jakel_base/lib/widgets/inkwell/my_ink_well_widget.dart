import 'package:flutter/material.dart';

import '../../theme/colors/my_colors.dart';

class MyInkWellWidget extends StatefulWidget {
  final Widget child;
  final GestureTapCallback? onTap;

  const MyInkWellWidget({Key? key, required this.child, required this.onTap})
      : super(key: key);

  @override
  _MyInkWellWidgetState createState() => _MyInkWellWidgetState();
}

class _MyInkWellWidgetState extends State<MyInkWellWidget> {
  @override
  Widget build(BuildContext context) {
    var color = getPrimaryColor(context) as Color;
    color = color.withOpacity(0.1);
    return InkWell(
      hoverColor: color,
      focusColor: color,
      splashColor: color,
      onTap: widget.onTap,
      child: widget.child,
    );
  }
}
