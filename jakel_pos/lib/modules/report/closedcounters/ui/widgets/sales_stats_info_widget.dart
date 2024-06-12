import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';

class SalesStatsInfoWidget extends StatefulWidget {
  final ClosedCounter closedCounter;

  const SalesStatsInfoWidget({Key? key, required this.closedCounter})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SalesStatsInfoState();
  }
}

class _SalesStatsInfoState extends State<SalesStatsInfoWidget> {
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
      "Sales Info",
      style: Theme.of(context).textTheme.bodyText1,
    ));
    widgets.add(const Divider());

    widgets.add(getPaymentsInfo("Type", "Total(RM)"));

    widgets.add(const Divider());

    widgets.add(getPaymentsInfo("Opening Balance",
        "${getDoubleValue(widget.closedCounter.openingBalance)}"));

    widgets.add(getPaymentsInfo("Closing Balance",
        "${getDoubleValue(widget.closedCounter.closingBalance)}"));

    widgets.add(getPaymentsInfo("Mismatch Amount",
        "${getDoubleValue(widget.closedCounter.mismatchAmount)}"));

    widgets.add(getPaymentsInfo("Total Sales Amount",
        "${getDoubleValue(widget.closedCounter.totalSalesAmount)}"));

    widgets.add(getPaymentsInfo("Total Layaway Sales Amount",
        "${getDoubleValue(widget.closedCounter.totalLayawaySalesAmount)}"));

    widgets.add(getPaymentsInfo("Total Void Sales Amount",
        "${getDoubleValue(widget.closedCounter.totalVoidedSalesAmount)}"));

    widgets.add(getPaymentsInfo("Total Tax Amount",
        "${getDoubleValue(widget.closedCounter.totalTaxAmount)}"));

    widgets.add(getPaymentsInfo("Total Sale Round Off",
        "${getDoubleValue(widget.closedCounter.totalSalesRoundOff)}"));

    widgets.add(getPaymentsInfo("Total Sale Returns Amount",
        "${getDoubleValue(widget.closedCounter.totalSaleReturnsAmount)}"));

    widgets.add(getPaymentsInfo("Total Sale Credit Notes Used Amount",
        "${getDoubleValue(widget.closedCounter.totalCreditNotesUsedAmount)}"));

    widgets.add(getPaymentsInfo("Total Sale Credit Notes Refunded Amount",
        "${getDoubleValue(widget.closedCounter.totalCreditNotesRefundedAmount)}"));

    widgets.add(getPaymentsInfo("Total Cashback Amount",
        "${getDoubleValue(widget.closedCounter.totalCashbackAmount)}"));

    widgets.add(getPaymentsInfo("Total Voucher Discount Amount",
        "${getDoubleValue(widget.closedCounter.totalVoucherDiscountAmount)}"));

    widgets.add(getPaymentsInfo("Total Booking Payment Amount",
        "${getDoubleValue(widget.closedCounter.totalBookingPaymentAmount)}"));

    widgets.add(getPaymentsInfo("Total Booking Payment Refunded Amount",
        "${getDoubleValue(widget.closedCounter.totalBookingPaymentRefundedAmount)}"));

    widgets.add(getPaymentsInfo("Total Booking Payment Used Amount",
        "${getDoubleValue(widget.closedCounter.totalBookingPaymentUsedAmount)}"));

    widgets.add(getPaymentsInfo("Total Cash In Amount",
        "${getDoubleValue(widget.closedCounter.totalCashInsAmount)}"));

    widgets.add(getPaymentsInfo("Total Cash Out Amount",
        "${getDoubleValue(widget.closedCounter.totalCashOutsAmount)}"));

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
