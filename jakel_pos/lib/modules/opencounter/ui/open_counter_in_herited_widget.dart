import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/GetCountersResponse.dart';
import 'package:jakel_base/restapi/counters/model/GetStoresResponse.dart';

class OpenCounterInHeritedWidget extends InheritedWidget {
  const OpenCounterInHeritedWidget({
    required Key key,
    required this.object,
    required Widget child,
  }) : super(key: key, child: child);

  final OpenCounterModel object;

  static OpenCounterInHeritedWidget of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<OpenCounterInHeritedWidget>()
        as OpenCounterInHeritedWidget;
  }

  @override
  bool updateShouldNotify(OpenCounterInHeritedWidget old) {
    return object != old.object;
  }
}

class OpenCounterModel {
  late Stores? store;
  late Counters? counters;
  late double? openingBalance;
  late bool counterLockedToThisMachine;

  OpenCounterModel(this.store, this.counters, this.openingBalance,
      this.counterLockedToThisMachine);
}
