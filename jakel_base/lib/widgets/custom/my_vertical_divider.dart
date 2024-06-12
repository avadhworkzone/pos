import 'package:flutter/material.dart';

class MyVerticalDivider extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final double? height;

  const MyVerticalDivider({Key? key, this.margin, this.height = 15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.0,
      height: height,
      margin: margin ?? const EdgeInsets.only(left: 10, right: 10),
      color: Theme.of(context).dividerColor,
    );
  }
}
