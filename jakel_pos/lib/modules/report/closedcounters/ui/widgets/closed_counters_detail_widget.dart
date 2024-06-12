import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/payments_info_widget.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/sales_stats_info_widget.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/sales_transaction_info_widget.dart';

class ClosedCountersDetailWidget extends StatefulWidget {
  final ClosedCounter closedCounter;

  const ClosedCountersDetailWidget({Key? key, required this.closedCounter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClosedCountersDetailWidgetState();
  }
}

class _ClosedCountersDetailWidgetState
    extends State<ClosedCountersDetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: const BoxConstraints.expand(),
        child: _getRootWidget(),
      ),
    );
  }

  _getRootWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getChildrenWidgets(),
      ),
    );
  }

  List<Widget> _getChildrenWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(
        PaymentsInfoWidget(payments: widget.closedCounter.salePayments ?? []));

    widgets.add(const SizedBox(height: 10));

    widgets.add(SalesStatsInfoWidget(
      closedCounter: widget.closedCounter,
    ));

    widgets.add(const SizedBox(height: 10));

    widgets.add(SalesTransactionInfoWidget(
      closedCounter: widget.closedCounter,
    ));

    return widgets;
  }
}
