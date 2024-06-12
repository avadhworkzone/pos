import 'package:flutter/material.dart';
import 'package:jakel_base/widgets/text/HeaderTextWidget.dart';

class MyTitleBackArrowWidget extends StatefulWidget {
  final String title;

  const MyTitleBackArrowWidget({Key? key, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyTitleBackArrowWidgetState();
  }
}

class _MyTitleBackArrowWidgetState extends State<MyTitleBackArrowWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
              size: 18.0,
            ),
            const SizedBox(
              width: 10,
            ),
            HeaderTextWidget(
              color: Theme.of(context).primaryColor,
              text: widget.title,
            )
          ],
        ));
  }
}
