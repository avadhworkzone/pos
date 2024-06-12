import 'package:flutter/material.dart';
import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';

class AddOpenPriceDialog extends StatefulWidget {
  final CartItem cartItem;
  final Function onPriceUpdated;

  const AddOpenPriceDialog(
      {Key? key, required this.cartItem, required this.onPriceUpdated})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddOpenPriceDialogState();
  }
}

class _AddOpenPriceDialogState extends State<AddOpenPriceDialog> {
  final amountController = TextEditingController();
  final amountNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    amountNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          height: 280,
          width: 500,
          child: MyDataContainerWidget(
            child: getRootWidget(),
          ),
        ));
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(getHeader());

    widgets.add(const Divider());

    widgets.add(const SizedBox(
      height: 5,
    ));

    widgets.add(Text(widget.cartItem.getProductName(),
        style: Theme.of(context).textTheme.caption));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(Text(
      "Minimum Price : ${getReadableAmount(getCurrency(), widget.cartItem.product?.minimumPrice)}",
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 15),
    ));

    widgets.add(const SizedBox(
      height: 10,
    ));

    widgets.add(MyTextFieldWidget(
      controller: amountController,
      node: amountNode,
      hint: "Enter price",
      onChanged: (value) {
        _onPriceEntered(value);
      },
    ));

    widgets.add(const SizedBox(
      height: 20,
    ));

    widgets.add(MyOutlineButton(
        text: "Done",
        onClick: () {
          _saveOpenPrice();
        }));

    widgets.add(const SizedBox(
      height: 5,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Add Open Price",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyInkWellWidget(
            child: const Icon(Icons.close),
            onTap: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  void _onPriceEntered(String value) {
    if (!isNumeric(value)) {
      amountController.text = "";
      showToast("Only numeric is allowed.", context);
      return;
    }
  }

  void _saveOpenPrice() {
    if (!isNumeric(amountController.text)) {
      amountController.text = "";
      showToast("Only numeric is allowed.", context);
      return;
    }

    double openPrice = getDoubleValue(amountController.text);

    if (openPrice < (widget.cartItem.product?.minimumPrice ?? 0)) {
      showToast("Price should be above specified minimum price", context);
    }else {
      widget.onPriceUpdated(widget.cartItem, openPrice);
      Navigator.pop(context);
    }
  }
}
