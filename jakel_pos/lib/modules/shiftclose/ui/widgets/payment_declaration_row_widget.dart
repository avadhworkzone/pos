import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/ShiftDetailsResponse.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/DecimalTextInputFormatter.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/ShiftCloseViewModel.dart';

class PaymentDeclarationRowWidget extends StatefulWidget {
  final ShiftClosingPayments payments;
  final double? alreadyEnteredAmount;
  final Function onAmountEntered;

  const PaymentDeclarationRowWidget(
      {Key? key,
      required this.payments,
      required this.alreadyEnteredAmount,
      required this.onAmountEntered})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PaymentDeclarationRowState();
  }
}

class _PaymentDeclarationRowState extends State<PaymentDeclarationRowWidget> {
  final viewModel = ShiftCloseViewModel();

  final keyController = TextEditingController();
  final keyFocusNode = FocusNode();

  final valueController = TextEditingController();
  final valueFocusNode = FocusNode();

  @override
  void dispose() {
    valueFocusNode.dispose();
    keyFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    keyController.text = "${widget.payments.paymentType}";
    valueController.text =
        "${(widget.alreadyEnteredAmount ?? 0) > 0 ? (widget.alreadyEnteredAmount ?? 0) : 0}";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.payments.paymentTypeId == cashPaymentId) {
      valueController.text = getOnlyReadableAmount(
          (widget.alreadyEnteredAmount ?? 0) > 0
              ? (widget.alreadyEnteredAmount ?? 0)
              : 0);
    }

    if (valueController.text.isEmpty) {
      valueController.text = "0";
    }

    if (valueController.text == "0") {
      //Place the cursor after actual text.
      valueController.selection =
          TextSelection.fromPosition(TextPosition(offset: 1));
    } else {
      //Place the cursor after actual text.
      valueController.selection = TextSelection.fromPosition(
          TextPosition(offset: valueController.text.length));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: getChildren(),
    );
  }

  List<Widget> getChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      width: 10,
    ));
    widgets.add(Expanded(
      flex: 1,
      child: TextField(
        controller: keyController,
        focusNode: keyFocusNode,
        enabled: false,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
          filled: true,
          fillColor: getWhiteColor(context),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                width: 1),
          ),
          hintText: "Declaration Type",
          hintStyle: Theme.of(context).textTheme.caption,
        ),
      ),
    ));
    widgets.add(const SizedBox(
      width: 10,
    ));
    widgets.add(Expanded(
      flex: 1,
      child: TextField(
        controller: valueController,
        focusNode: valueFocusNode,
        enabled: widget.payments.paymentTypeId != cashPaymentId,
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          try {
            if (value == "0") {
              valueController.text = "0";
              widget.onAmountEntered(widget.payments, 0.0);
            } else {
              String enteredValue = valueController.text;

              if (enteredValue.startsWith("0")) {
                enteredValue = value.split("0")[1];
              }

              valueController.text = enteredValue;
              widget.onAmountEntered(double.parse(enteredValue));
            }
          } catch (e) {
            showToast("Only numeric is allowed.", context);
            valueController.text = "";
          }
        },
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(4, 4, 0, 0),
          filled: true,
          fillColor: getWhiteColor(context),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.6),
                width: 1),
          ),
          hintText: "Enter quantity",
          hintStyle: Theme.of(context).textTheme.caption,
        ),
      ),
    ));
    widgets.add(const SizedBox(
      width: 10,
    ));

    widgets.add(const SizedBox(
      width: 10,
    ));

    return widgets;
  }
}
