import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';

import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';

import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/button/MyPrimaryButton.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';

import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/giftcard/GiftCardViewModel.dart';

class SelectGiftCardWidget extends StatefulWidget {
  final double totalPayableAmount;
  final Function saveGiftCard;
  final Function removeGiftCard;
  final int sGiftCardId;
  final double removeAmount;

  const SelectGiftCardWidget({
    Key? key,
    required this.sGiftCardId,
    required this.removeAmount,
    required this.totalPayableAmount,
    required this.saveGiftCard,
    required this.removeGiftCard,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectGiftCardState();
  }
}

class _SelectGiftCardState extends State<SelectGiftCardWidget> {
  bool callApi = false;

  final numberController = TextEditingController();
  final numberNode = FocusNode();

  final viewModel = GiftCardViewModel();
  double amountTobeUsedFromGiftCard = 0;
  var isLoadedOnce = false;
  GiftCards? selectedGiftCard;
  String? errorMessage;

  @override
  void initState() {
    if (widget.sGiftCardId != -1) {
      numberController.text = widget.sGiftCardId.toString();
      callGiftCardApi(widget.sGiftCardId.toString());
    }
    super.initState();
  }

  callGiftCardApi(String sValue) {
    viewModel.getGiftCardDetails(sValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: 600,
        width: 550,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            getHeader(),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            Expanded(child: getRootWidget())
          ],
        ),
      ),
    );
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Enter Points
    widgets.add(
      widget.sGiftCardId == -1
          ? MyTextFieldWidget(
              controller: numberController,
              node: numberNode,
              keyboardType: TextInputType.number,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  callGiftCardApi(value);
                }
              },
              hint: "Enter gift card number to be used",
            )
          : SizedBox(),
    );
    widgets.add(const SizedBox(
      height: 20,
    ));
    widgets.add(Expanded(child: getGiftWidget()));

    widgets.add(const SizedBox(
      height: 20,
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
          'Select Gift Cards',
          style: TextStyle(
            fontSize: 18,
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

  Widget getGiftWidget() {
    return StreamBuilder<GiftCards>(
      stream: viewModel.responseSubjectGiftCardsDetails,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("No gift card available");
        }
        if (snapshot.connectionState == ConnectionState.active) {
          selectedGiftCard = snapshot.data;

          errorMessage =
              "This gift card will expired on ${selectedGiftCard?.expiryDate}";

          if (viewModel.isAlreadyUsed(selectedGiftCard)) {
            errorMessage = "This gift card is already used";
            selectedGiftCard = null;
          }

          if (viewModel.isExpired(selectedGiftCard)) {
            errorMessage =
                "This gift card is expired on ${selectedGiftCard?.expiryDate}";
            selectedGiftCard = null;
          }

          _updateAmountToBeUsed();
          return buttonAndGiftCardDetails();
        }
        return const Text("Please enter gift card number ...");
      },
    );
  }

  Widget buttonAndGiftCardDetails() {
    List<Widget> widgets = List.empty(growable: true);

    if (errorMessage != null) {
      widgets.add(
        Text(errorMessage ?? ""),
      );
      widgets.add(
        const SizedBox(
          height: 10,
        ),
      );
    }

    if (selectedGiftCard != null) {
      widgets.add(
        Text(
            "Gift card is active & available amount :  ${getReadableAmount(getCurrency(), selectedGiftCard?.availableAmount)}"),
      );
      widgets.add(
        const SizedBox(
          height: 10,
        ),
      );
      widgets.add(
        Text(
            "Amount to be used : ${getReadableAmount(getCurrency(), amountTobeUsedFromGiftCard)}"),
      );
      widgets.add(
        const SizedBox(
          height: 10,
        ),
      );
      widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.sGiftCardId == -1
                ? MyOutlineButton(text: 'Save', onClick: _save)
                : SizedBox(),
            widget.sGiftCardId != -1
                ? MyPrimaryButton(
                    text: "Remove",
                    onClick: () {
                      _remove();
                    })
                : SizedBox()
          ],
        ),
      );
    }

    widgets.add(
      const SizedBox(
        height: 10,
      ),
    );

    return Column(children: widgets);
  }

  void _updateAmountToBeUsed() {
    if (widget.sGiftCardId == -1) {
      if (widget.totalPayableAmount >
          (selectedGiftCard?.availableAmount ?? 0)) {
        amountTobeUsedFromGiftCard = (selectedGiftCard?.availableAmount ?? 0);
      }

      if ((selectedGiftCard?.availableAmount ?? 0) >=
          widget.totalPayableAmount) {
        amountTobeUsedFromGiftCard = widget.totalPayableAmount;
      }
    } else {
      amountTobeUsedFromGiftCard = widget.removeAmount;
    }
  }

  void _save() {
    widget.saveGiftCard(selectedGiftCard, amountTobeUsedFromGiftCard);
    Navigator.of(context).pop();
  }

  void _remove() {
    widget.removeGiftCard(selectedGiftCard, widget.removeAmount);
    Navigator.of(context).pop();
  }
}
