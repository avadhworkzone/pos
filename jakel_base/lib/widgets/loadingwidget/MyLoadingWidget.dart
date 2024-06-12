import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyLoadingWidget extends StatelessWidget {
  const MyLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
