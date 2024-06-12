import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';

class SalesTransactionInfoWidget extends StatefulWidget {
  final ClosedCounter closedCounter;

  const SalesTransactionInfoWidget({Key? key, required this.closedCounter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SalesTransactionInfoState();
  }
}

class _SalesTransactionInfoState extends State<SalesTransactionInfoWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getPaymentsCalculationWidget();
  }

  Widget getPaymentsCalculationWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(Text(
      "Transaction Details",
      style: Theme.of(context).textTheme.bodyText1,
    ));
    widgets.add(const Divider());

    widgets.add(getPaymentsInfo("Type", "Count"));

    widgets.add(const Divider());

    widgets.add(
        getPaymentsInfo("Total Sales", "${widget.closedCounter.totalSales}"));

    widgets.add(getPaymentsInfo(
        "Total Layaway Sales", "${widget.closedCounter.totalLayawaySales}"));

    widgets.add(getPaymentsInfo(
        "Total Voided Sales", "${widget.closedCounter.totalVoidedSales}"));

    widgets.add(getPaymentsInfo(
        "Total Sale Returns", "${widget.closedCounter.totalSaleReturns}"));

    widgets.add(getPaymentsInfo(
        "Total Vouchers Used", "${widget.closedCounter.totalVouchersUsed}"));

    widgets.add(getPaymentsInfo("Total Vouchers Generated",
        "${widget.closedCounter.totalVouchersGenerated}"));

    return MyDataContainerWidget(
      child: IntrinsicHeight(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }

  Widget getPaymentsInfo(String key, String total) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Text(
            key,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              getOnlyReadableAmount(total),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
        const SizedBox(
          width: 20,
        )
      ]),
    );
  }

  Widget getSalesStatistics(String key, String total) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(children: [
        Expanded(
          flex: 2,
          child: Text(
            key,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
            flex: 1,
            child: Text(
              getOnlyReadableAmount(total),
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyLarge,
            )),
        const SizedBox(
          width: 20,
        )
      ]),
    );
  }
}
