import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/counters/model/CloseCounterRequest.dart';
import 'package:jakel_base/theme/colors/my_colors.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/shiftclose/ShiftCloseViewModel.dart';
import 'package:jakel_pos/modules/shiftclose/ui/widgets/shift_close_inherited_widget.dart';

class DenominationRowWidget extends StatefulWidget {
  final int pos;
  final ValueChanged<int> removeOnPosition;
  final Function addNewItem;
  final String hintText;
  final Denominations denomination;
  final Function refresh;

  const DenominationRowWidget(
      {Key? key,
      required this.pos,
      required this.removeOnPosition,
      required this.denomination,
      required this.addNewItem,
      required this.refresh,
      required this.hintText})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DenominationRowState();
  }
}

class _DenominationRowState extends State<DenominationRowWidget> {
  final viewModel = ShiftCloseViewModel();

  final keyController = TextEditingController();
  final keyFocusNode = FocusNode();

  final valueController = TextEditingController();
  final valueFocusNode = FocusNode();

  late bool isDeclarationDone = false;

  @override
  void dispose() {
    valueFocusNode.dispose();
    keyFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.denomination.denomination != null) {
      keyController.text =
          getStringWithTwoDecimal(widget.denomination.denomination);
    }

    if (widget.denomination.quantity != null) {
      valueController.text = "${widget.denomination.quantity}";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Place the cursor after actual text.
    isDeclarationDone = ShiftCloseInheritedWidget.of(context)
            .shiftDeclaration
            .isDeclarationDone ??
        false;

    valueController.selection = TextSelection.fromPosition(
        TextPosition(offset: valueController.text.length));

    if (valueController.text.isEmpty) {
      valueController.text = "0";
    }

    return SizedBox(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: getChildren(),
      ),
    );
  }

  List<Widget> getChildren() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(const SizedBox(
      width: 10,
    ));

    widgets.add(Expanded(
        flex: 2,
        child: SizedBox(
          height: 30,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(keyController.text),
          ),
        )));
    widgets.add(const SizedBox(
      width: 30,
    ));
    if (isDeclarationDone) {
      widgets.add(Expanded(
        flex: 3,
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: getWhiteColor(context),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(3))),
          child: Text(
            valueController.text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ));
    } else {
      widgets.add(Expanded(
        flex: 3,
        child: TextField(
          controller: valueController,
          focusNode: valueFocusNode,
          keyboardType: TextInputType.number,
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (value) {
            _onDenominationQtyEntered(value);
          },
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
    }
    widgets.add(const SizedBox(
      width: 10,
    ));

    widgets.add(SizedBox(
      width: 100,
      child: Text(
        getTotalRowAmount(),
        textAlign: TextAlign.right,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ));

    widgets.add(const SizedBox(
      width: 10,
    ));

    return widgets;
  }

  void _onDenominationQtyEntered(String value) {
    try {
      if (value == "0") {
        valueController.text = "0";
        widget.denomination.quantity = 0;
      } else {
        String enteredValue = valueController.text;

        if (enteredValue.startsWith("0")) {
          enteredValue = value.split("0")[1];
        }
        valueController.text = enteredValue;
        widget.denomination.quantity = int.parse(enteredValue);
      }
    } catch (e) {
      widget.denomination.quantity = 0;
      valueController.text = "";
      showToast("Only numeric is allowed.", context);
    }
    widget.refresh();
  }

  String getTotalRowAmount() {
    try {
      int qty = widget.denomination.quantity ?? 0;
      double value = widget.denomination.denomination ?? 0.0;
      return getReadableAmount(getCurrency(), value * qty);
    } catch (e) {
      return "RM 0.00";
    }
  }
}
