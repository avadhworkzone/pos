import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/counters/model/PaymentDeclarationAttemptsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';

import '../../ShiftCloseViewModel.dart';

class PaymentDeclarationAttemptsInfoWidget extends StatefulWidget {
  final List<AttemptPayments> attemptPayments;

  const PaymentDeclarationAttemptsInfoWidget(
      {Key? key, required this.attemptPayments})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentDeclarationAttemptsInfoState();
  }
}

class _PaymentDeclarationAttemptsInfoState
    extends State<PaymentDeclarationAttemptsInfoWidget> {
  final viewModel = ShiftCloseViewModel();

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

    widgets.add(
        getMismatchDetails("Type", "Discrepancy(RM)", "Declared(RM)", null));

    widgets.add(const Divider());

    for (var element in widget.attemptPayments) {
      widgets.add(getMismatchDetails(
          element.paymentTypeName ?? noData,
          getOnlyReadableAmount(getDoubleValue(element.declaredAmount) -
              getDoubleValue(element.calculatedAmount)),
          getOnlyReadableAmount(element.declaredAmount),
          element.declaredAmount != element.calculatedAmount));

      widgets.add(const SizedBox(
        height: 5,
      ));

      if (element.denominations != null && element.denominations!.isNotEmpty) {
        widgets.add(const Divider());

        widgets.add(Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Denominations",
                style: Theme.of(context).textTheme.caption,
              ),
            )));

        widgets.add(const SizedBox(
          height: 20,
        ));

        element.denominations?.forEach((element) {
          widgets.add(Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(children: [
              Expanded(
                flex: 2,
                child: Text(
                  '${element.denomination}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Text(
                'x',
                style: Theme.of(context).textTheme.caption,
              ),
              Expanded(
                  flex: 2,
                  child: Text(
                    '${element.quantity}',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
            ]),
          ));

          widgets.add(const Padding(
              padding: EdgeInsets.only(left: 50), child: Divider()));
        });
        widgets.add(const SizedBox(
          height: 10,
        ));
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

  Widget getMismatchDetails(
      String key, String expected, String actual, bool? isMismatch) {
    return Row(children: [
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
            getOnlyReadableAmount(expected),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
      Expanded(
          flex: 1,
          child: Text(
            getOnlyReadableAmount(actual),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
      const SizedBox(
        width: 20,
      ),
      isMismatch != null
          ? (isMismatch == true)
              ? const Icon(
                  Icons.close,
                  color: Colors.red,
                )
              : const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                )
          : const SizedBox(width: 20)
    ]);
  }
}
