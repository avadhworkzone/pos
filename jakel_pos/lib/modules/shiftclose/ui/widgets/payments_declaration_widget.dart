import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/payment_declaration_row_widget.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';

import '../../ShiftCloseViewModel.dart';

class PaymentsDeclarationWidget extends StatefulWidget {
  final CounterClosingDetails counter;
  final Function onPaymentDeclaration;

  const PaymentsDeclarationWidget(
      {Key? key, required this.counter, required this.onPaymentDeclaration})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentsDeclarationWidgetState();
  }
}

class _PaymentsDeclarationWidgetState extends State<PaymentsDeclarationWidget> {
  final viewModel = ShiftCloseViewModel();

  late HashMap<int, double> paymentAmountDeclaration;

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
    paymentAmountDeclaration = ShiftCloseInheritedWidget.of(context)
            .shiftDeclaration
            .paymentDeclaration ??
        HashMap();
    return getPaymentsWidgets();
  }

  Widget getPaymentsWidgets() {
    List<Widget> widgets = List.empty(growable: true);

    // If no cash payment is made & still opening balance is added then,
    // it should shown in declaration

    widget.counter.payments?.forEach((element) {
      if (element.paymentTypeId != bookingPaymentId &&
          element.paymentTypeId != creditNotePaymentId &&
          element.paymentTypeId != loyaltyPointPaymentId) {
        widgets.add(PaymentDeclarationRowWidget(
            payments: element,
            alreadyEnteredAmount:
            customRound((paymentAmountDeclaration[element.paymentTypeId] ?? 0.0),2) ,
            onAmountEntered: (amountEntered) {
              setState(() {
                paymentAmountDeclaration[element.paymentTypeId ?? 0] =
                    amountEntered;
                widget.onPaymentDeclaration(paymentAmountDeclaration);
              });
            }));

        widgets.add(const SizedBox(
          height: 10,
        ));
      }
    });

    return IntrinsicHeight(
      child: Column(
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
}
