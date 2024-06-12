import 'package:flutter/material.dart';
import 'package:jakel_base/constants.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/custom/my_square_content_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';

import '../../ShiftCloseViewModel.dart';

class PaymentsInfoWidget extends StatefulWidget {
  final CounterClosingDetails counter;

  const PaymentsInfoWidget({Key? key, required this.counter}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentsInfoWidgetState();
  }
}

class _PaymentsInfoWidgetState extends State<PaymentsInfoWidget> {
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
        getMismatchDetails("Type", "Declared(RM)", null));

    widgets.add(const Divider());

    widget.counter.payments?.forEach((element) {
      if (element.paymentTypeId != bookingPaymentId &&
          element.paymentTypeId != creditNotePaymentId &&
          element.paymentTypeId != loyaltyPointPaymentId) {
        double declaredAmount = ShiftCloseInheritedWidget.of(context)
                .shiftDeclaration
                .paymentDeclaration![element.paymentTypeId] ??
            0.0;

        if (element.paymentTypeId == cashPaymentId) {
          double expectedCash = viewModel.getExpectedCash(
              ShiftCloseInheritedWidget.of(context)
                  .shiftDeclaration
                  .closingDetails!);

          widgets.add(getMismatchDetails(
              element.paymentType ?? noData,
              getOnlyReadableAmount(declaredAmount),
              declaredAmount != expectedCash));
          widgets.add(const SizedBox(
            height: 5,
          ));
        } else {
          widgets.add(getMismatchDetails(
              element.paymentType ?? noData,
              getOnlyReadableAmount(declaredAmount),
              declaredAmount != element.total));
          widgets.add(const SizedBox(
            height: 5,
          ));
        }
      }
    });

    return MyDataContainerWidget(
      child: IntrinsicHeight(
        child: Column(
          children: widgets,
        ),
      ),
    );
  }



  Widget getPaymentsWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    int colorType = 1;
    widget.counter.payments?.forEach((element) {
      if (colorType > 5) {
        colorType = 1;
      }
      widgets.add(MySquareContentWidget(
          title: element.paymentType ?? noData,
          value: getOnlyReadableAmount(element.total),
          color: getColor(colorType),
          isSelected: true,
          size: 140));
      colorType += 1;
    });

    return IntrinsicHeight(
      child: Wrap(
        runSpacing: 5.0,
        spacing: 5.0,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: widgets,
      ),
    );
  }

  Color getColor(int type) {
    if (type == 1) {
      return Colors.purple;
    }

    if (type == 2) {
      return Colors.teal;
    }

    if (type == 3) {
      return Colors.orange;
    }

    if (type == 4) {
      return Theme.of(context).colorScheme.primaryContainer;
    }
    return Colors.blueGrey;
  }

  Widget getMismatchDetails(
      String key, String actual, bool? isMismatch) {
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
            getOnlyReadableAmount(actual),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
      SizedBox(
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
