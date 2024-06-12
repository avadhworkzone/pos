import 'package:flutter/material.dart';
import 'package:jakel_pos/modules/home/model/HomeMenuItem.dart';

class HomeInheritedWidget extends InheritedWidget {
  const HomeInheritedWidget({
    Key? key,
    required this.object,
    required Widget child,
  })  : super(key: key, child: child);

  final HomeDataModel object;

  static HomeInheritedWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeInheritedWidget>()
        as HomeInheritedWidget;
  }

  @override
  bool updateShouldNotify(HomeInheritedWidget old) {
    return object != old.object;
  }
}

class HomeDataModel {
  late HomeMenuItem menuItem;

  HomeDataModel(this.menuItem);
}
