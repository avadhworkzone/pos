import 'package:flutter/material.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';

class MyBackgroundWidget extends StatelessWidget {
  final Widget child;

  const MyBackgroundWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var color = getPrimaryColor(context) as Color;
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [color.withOpacity(0.1), color.withOpacity(0.1)],
      )),
      child: child,
    );
  }
}
