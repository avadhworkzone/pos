import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/creditnote/CreditNoteViewModel.dart';
import 'package:jakel_pos/modules/refundCreditNote/RefundCreditNoteViewModel.dart';
import 'package:jakel_pos/modules/saleshistory/SalesHistoryViewModel.dart';

class BookingCreditNoteWidget extends StatefulWidget {
  final Function refundCreditNote;
  final RefundCreditNoteViewModel mRefundViewModel;

  const BookingCreditNoteWidget({
    Key? key,
    required this.refundCreditNote,
    required this.mRefundViewModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookingCreditNoteState();
  }
}

class _BookingCreditNoteState extends State<BookingCreditNoteWidget> {
  bool callApi = false;

  final numberController = TextEditingController();
  final numberNode = FocusNode();

  final viewModel = CreditNoteViewModel();
  double amountTobeUsedFromCreditNote = 0;
  var isLoadedOnce = false;
  late var height;
  late var selectedCreditNote;
  var sentAmount = 0.0;

  final enterNumberController = TextEditingController();
  final enterNumberNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  callCreditNoteApi(String sValue) {
    viewModel.getCreditNotesDetails(sValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return getRootWidget();
  }

  Widget getRootWidget() {
    List<Widget> widgets = List.empty(growable: true);

    // Enter Points

    widgets.add(
      MyTextFieldWidget(
        controller: numberController,
        node: numberNode,
        keyboardType: TextInputType.number,
        onSubmitted: (value) async {
          if (value.isNotEmpty) {
            callCreditNoteApi(value);
          }
        },
        hint: "Enter credit note number",
      ),
    );
    widgets.add(const SizedBox(
      height: 15,
    ));
    widgets.add(Expanded(child: validateAndGetCreditNote()));

    widgets.add(const SizedBox(
      height: 10,
    ));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }

  Widget buttonAndCreditNoteDetails() {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(creditNoteWidget());

    return Column(children: widgets);
  }

  Widget validateAndGetCreditNote() {
    if (numberController.text.isEmpty) {
      return const Text("Please enter credit note number ...");
    } else {
      return buttonAndCreditNoteDetails();
    }
  }

  Widget creditNoteWidget() {
    return StreamBuilder<CreditNotesApiResponse>(
      stream: viewModel.responseSubject,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingWidget();
        }
        if (snapshot.hasError) {
          return MyErrorWidget(message: "Error", tryAgain: () {});
        }
        if (snapshot.connectionState == ConnectionState.active) {
          selectedCreditNote = snapshot.data;
          if (selectedCreditNote.creditNote != null) {
            return Flexible(
                child: SizedBox(
              height: height * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Status :"),
                          Text("${selectedCreditNote.creditNote!.status}"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Credit Note total amount :"),
                          Text(getReadableAmount(getCurrency(),
                              selectedCreditNote?.creditNote!.totalAmount)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Credit Note available amount :"),
                          Text(getReadableAmount(getCurrency(),
                              selectedCreditNote?.creditNote!.availableAmount)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextFieldWidget(
                    controller: enterNumberController,
                    node: enterNumberNode,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && !getValueCheck(value)) {
                        setState(() {
                          enterNumberController.text =
                              value.toString().substring(0, value.length - 1);
                          enterNumberController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: enterNumberController.text.length));
                        });
                      } else if (value.isNotEmpty &&
                          value.split(".").length > 2) {
                        setState(() {
                          enterNumberController.text =
                              value.toString().substring(0, value.length - 1);
                          enterNumberController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: enterNumberController.text.length));
                        });
                      } else if (value.isNotEmpty &&
                          value.split(".").length == 2 &&
                          value.split(".")[1].length > 2) {
                        setState(() {
                          enterNumberController.text =
                              value.toString().substring(0, value.length - 1);
                          enterNumberController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: enterNumberController.text.length));
                        });
                      }

                      if (value.isNotEmpty &&
                          getDoubleValue(value) >
                              getDoubleValue(selectedCreditNote
                                  ?.creditNote!.availableAmount)) {
                        setState(() {
                          enterNumberController.text =
                              value.toString().substring(0, value.length - 1);
                          enterNumberController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: enterNumberController.text.length));
                        });
                      }
                    },
                    hint: "Enter No",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  widget.mRefundViewModel.isActive(selectedCreditNote)
                      ? SizedBox(
                          width: 100,
                          height: 35,
                          child: MyOutlineButton(
                            text: 'Done',
                            onClick: _refund,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ));
          } else if (selectedCreditNote.creditNote.toString() == "null") {
            return const Text("This credit note number not exist ...");
          }
        }
        return Container();
      },
    );
  }

  void _refund() {
    if (enterNumberController.text.isNotEmpty) {
      widget.refundCreditNote(selectedCreditNote.creditNote,
          getDoubleValue(enterNumberController.text));
    } else {
      showToast("Please enter the amount", context);
    }
  }
}
