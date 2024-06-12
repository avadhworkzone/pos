import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';

import 'package:jakel_base/widgets/appbgwidget/MyBackgroundWidget.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/closed_counters_detail_widget.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/closed_counters_history_widget.dart';

class ClosedCounterReportScreen extends StatefulWidget {
  const ClosedCounterReportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClosedCounterReportState();
  }
}

class _ClosedCounterReportState extends State<ClosedCounterReportScreen>
    with SingleTickerProviderStateMixin {
  ClosedCounter? _selected;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: MyBackgroundWidget(child: rootWidget()));
  }

  Widget rootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Tab children view
    widgets.add(
      Expanded(flex: 4, child: mainWidget(context)),
    );

    if (_selected != null) {
      widgets.add(Expanded(
          flex: 4,
          child: ClosedCountersDetailWidget(
            closedCounter: _selected!,
          )));
    } else {
      widgets.add(const Expanded(
          flex: 4,
          child: Center(
            child: Text("Please select counter"),
          )));
    }

    return Container(
        margin: const EdgeInsets.all(5.0),
        child: Row(
          children: widgets,
        ));
  }

  Widget mainWidget(BuildContext context) {
    return ClosedCountersHistoryWidget(onSelected: (closedCounterData) {
      setState(() {
        _selected = closedCounterData;
      });
    });
  }
}
