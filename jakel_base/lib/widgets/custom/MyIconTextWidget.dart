import 'package:flutter/material.dart';

class MyIconTextWidget extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function onTap;
  final bool isRightAligned;

  MyIconTextWidget(
      {Key? key,
      required this.iconData,
      required this.text,
      required this.onTap,
      required this.isRightAligned})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Row(
        mainAxisAlignment:
            (isRightAligned) ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: Theme.of(context).primaryColor,
            size: 16,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(text, style: Theme.of(context).textTheme.caption)
        ],
      ),
    );
  }
}
