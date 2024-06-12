import 'package:flutter/material.dart';

class MyDataContainerWidget extends StatelessWidget {
  final Widget child;
  final double? padding;

  const MyDataContainerWidget({Key? key, required this.child, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding == null ? 15.0 : padding!),
      decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .onPrimaryContainer
              .withOpacity(0.5),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: child,
    );
  }
}
