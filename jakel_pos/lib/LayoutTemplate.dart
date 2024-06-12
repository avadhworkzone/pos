import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LayoutTemplate extends StatelessWidget {
  final Widget child;

  const LayoutTemplate({required this.child}) : super();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getFileData(),
        initialData: "Loading ..",
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.data != null && snapshot.data == "value") {
            return ResponsiveBuilder(
              builder: (context, sizingInformation) => Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                body: SafeArea(
                  child: child,
                ),
              ),
            );
          }
          return const Text("Loading Widget");
        });
  }

  Future<String> getFileData() async {
    return await Future(() => "value");
  }
}
