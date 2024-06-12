import 'package:flutter/material.dart';

class MySmallBoxWidget extends StatelessWidget {
  final String title, value;
  bool underline = false;

  MySmallBoxWidget(
      {Key? key,
      required this.title,
      required this.value,
      this.underline = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      decoration: underline
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: underline
                          ? Theme.of(context).primaryColor
                          : Colors.black)),
              SelectableText(
                value,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
