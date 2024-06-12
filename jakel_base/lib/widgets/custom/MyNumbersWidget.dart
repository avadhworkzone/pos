import 'package:flutter/material.dart';

class MyNumbersWidget extends StatelessWidget {
  final String text;
  final Function? onCLick;
  final Function? doubleClick;
  final double numbersPadding = 6.0;

  MyNumbersWidget(
      {Key? key, required this.text, this.onCLick, this.doubleClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      hoverColor: Theme
          .of(context)
          .primaryColor,
      focusColor: Theme
          .of(context)
          .primaryColor,
      splashColor: Theme
          .of(context)
          .primaryColor,
      onDoubleTap: () {
        if (doubleClick != null) {
          doubleClick!();
        }
      },
      onTap: () {
        if (onCLick != null) {
          onCLick!();
        }
      },
      child: Container(
        margin: const EdgeInsets.all(1.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme
                .of(context)
                .dividerColor, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(numbersPadding),
              child: Text(
                text,
                style: Theme
                    .of(context)
                    .textTheme
                    .subtitle2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
