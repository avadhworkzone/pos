import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/giftcards/model/GiftCardsResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/creditnote/CreditNoteViewModel.dart';
import 'package:jakel_pos/modules/giftcard/GiftCardViewModel.dart';
import 'package:jakel_pos/modules/refundCreditNote/RefundCreditNoteViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';

class BookingGiftCardPaymentWidget extends StatefulWidget {

  final Function saveGiftCard;

  const BookingGiftCardPaymentWidget({
    Key? key,
    required this.saveGiftCard,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingGiftCardPaymentState();
  }
}

class _BookingGiftCardPaymentState extends State<BookingGiftCardPaymentWidget> {
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
    super.initState();
  }

  callGiftCardApi(String sValue) {
    viewModel.getGiftCardDetails(sValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return getRootWidget();
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Enter Points
    widgets.add(MyTextFieldWidget(
      controller: numberController,
      node: numberNode,
      keyboardType: TextInputType.number,
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          callGiftCardApi(value);
        }
      },
      hint: "Enter gift card number to be used",
    ));
    widgets.add(const SizedBox(
      height: 20,
    ));
    widgets.add(Expanded(child: getGiftWidget()));


    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
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
          children: [MyOutlineButton(text: 'Save', onClick: _save)],
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
    amountTobeUsedFromGiftCard = (selectedGiftCard?.availableAmount ?? 0);
  }

  void _save() {
    widget.saveGiftCard(selectedGiftCard, amountTobeUsedFromGiftCard);
    Navigator.of(context).pop();
  }
}
