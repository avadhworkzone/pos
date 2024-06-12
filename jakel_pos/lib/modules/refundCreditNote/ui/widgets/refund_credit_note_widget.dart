import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/creditnote/CreditNoteViewModel.dart';
import 'package:jakel_pos/modules/refundCreditNote/RefundCreditNoteViewModel.dart';

class RefundCreditNoteWidget extends StatefulWidget {
  final Function refundCreditNote;
  final RefundCreditNoteViewModel mRefundViewModel;

  const RefundCreditNoteWidget({
    Key? key,
    required this.refundCreditNote, required this.mRefundViewModel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundCreditNoteState();
  }
}

class _RefundCreditNoteState extends State<RefundCreditNoteWidget> {
  bool callApi = false;

  final numberController = TextEditingController();
  final numberNode = FocusNode();

  final viewModel = CreditNoteViewModel();
  double amountTobeUsedFromCreditNote = 0;
  var isLoadedOnce = false;
  late var width;
  late var height;
  late var selectedCreditNote;

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
    width = MediaQuery.of(context).size.width;
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
      height: 20,
    ));
    widgets.add(Expanded(child: validateAndGetCreditNote()));

    widgets.add(const SizedBox(
      height: 20,
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
              height: height * 0.4,
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
                          const Text("Credit Note Amount :"),
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
                          const Text("Available Credit Note Amount :"),
                          Text(getReadableAmount(getCurrency(),
                              selectedCreditNote?.creditNote!.availableAmount)),
                        ],
                      ),
                    ],
                  ),
                widget.mRefundViewModel.isActive(selectedCreditNote)
                      ? SizedBox(
                          width: 100,
                          height: 40,
                          child: MyOutlineButton(
                            text: 'Refund',
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
    widget.refundCreditNote(
      selectedCreditNote.creditNote,
    );
  }
}
