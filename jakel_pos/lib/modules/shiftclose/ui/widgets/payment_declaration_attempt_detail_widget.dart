import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/payments_info_widget.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/sales_stats_info_widget.dart';
import 'package:jakel_pos/modules/report/closedcounters/ui/widgets/sales_transaction_info_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/payments_declaration_attempts_info_widget.dart';

class PaymentDeclarationAttemptDetailWidget extends StatefulWidget {
  final CounterUpdateDeclarationAttempts attempts;

  const PaymentDeclarationAttemptDetailWidget(
      {Key? key, required this.attempts})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentDeclarationAttemptsState();
  }
}

class _PaymentDeclarationAttemptsState
    extends State<PaymentDeclarationAttemptDetailWidget> {
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

    widgets.add(PaymentDeclarationAttemptsInfoWidget(
      attemptPayments: widget.attempts.payments ?? [],
    ));

    return widgets;
  }
}
