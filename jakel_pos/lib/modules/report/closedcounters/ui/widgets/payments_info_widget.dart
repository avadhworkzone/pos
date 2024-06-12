import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ClosedCountesrHistoryResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';

class PaymentsInfoWidget extends StatefulWidget {
  final List<SalePayments> payments;

  const PaymentsInfoWidget({Key? key, required this.payments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentsInfoWidgetState();
  }
}

class _PaymentsInfoWidgetState extends State<PaymentsInfoWidget> {
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
      "Payments Info",
      style: Theme.of(context).textTheme.bodyText1,
    ));
    widgets.add(const Divider());

    widgets.add(getPaymentsInfo("Type", "Total(RM)"));

    widgets.add(const Divider());

    for (var element in widget.payments) {
      if (element.paymentTypeId != bookingPaymentId &&
          element.paymentTypeId != creditNotePaymentId &&
          element.paymentTypeId != loyaltyPointPaymentId) {
        widgets
            .add(getPaymentsInfo("${element.paymentType}", "${element.total}"));
      }
    }

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
