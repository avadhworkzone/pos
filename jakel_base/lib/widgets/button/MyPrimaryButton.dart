import 'package:flutter/material.dart';

import '../../theme/colors/my_colors.dart';

enum PrimaryButtonType { NORMAL, OUTLINE, OUTLINE_WITH_RIGHT_ARROW }

class MyPrimaryButton extends StatelessWidget {
  final GestureTapCallback onClick;
  String text;
  EdgeInsets? padding;
  PrimaryButtonType? type;
  bool? disable;

  MyPrimaryButton(
      {super.key,
      required this.text,
      this.disable,
      required this.onClick,
      this.padding = const EdgeInsets.all(10.0),
      this.type});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
          decoration: boxDecoration(context),
          padding: padding,
          child: mainWidget(context)),
    );
  }

  Widget mainWidget(BuildContext context) {
    if (type != null && type == PrimaryButtonType.OUTLINE_WITH_RIGHT_ARROW) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.button,
          ),
          Icon(
            Icons.arrow_forward_outlined,
            color: getPrimaryColor(context),
          )
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.button,
        ),
      ],
    );
  }

  BoxDecoration boxDecoration(BuildContext context) {
    if (type != null &&
        (type == PrimaryButtonType.OUTLINE ||
            type == PrimaryButtonType.OUTLINE_WITH_RIGHT_ARROW)) {
      return BoxDecoration(
          border: Border.all(
            color: getColor(context),
          ),
          borderRadius: BorderRadius.all(Radius.circular(5)));
    }
    return BoxDecoration(
        color: getColor(context),
        borderRadius: BorderRadius.all(Radius.circular(5)));
  }

  Color getColor(BuildContext context) {
    if (disable != null && disable == false) {
      return getPrimaryColor(context).withOpacity(0.4);
    }
    return getPrimaryColor(context);
  }
}
