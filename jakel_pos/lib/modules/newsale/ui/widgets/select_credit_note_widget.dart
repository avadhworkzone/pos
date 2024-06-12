import 'package:flutter/material.dart';
import 'package:jakel_base/jakel_base.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_base/widgets/errorwidget/MyErrorWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_base/widgets/loadingwidget/MyLoadingWidget.dart';
import 'package:jakel_base/widgets/textfield/MyTextFieldWidget.dart';
import 'package:jakel_pos/modules/creditnote/CreditNoteViewModel.dart';

class SelectCreditNoteWidget extends StatefulWidget {
  final Function saveCreditNote;
  final Function removeCreditNote;
  final double totalPayableAmount;
  final double removeAmount;
  final int sCreditNoteId;

  const SelectCreditNoteWidget({
    Key? key,
    required this.sCreditNoteId,
    required this.totalPayableAmount,
    required this.removeAmount,
    required this.saveCreditNote,
    required this.removeCreditNote,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SelectCreditNoteState();
  }
}

class _SelectCreditNoteState extends State<SelectCreditNoteWidget> {
  bool callApi = false;

  final numberController = TextEditingController();
  final numberNode = FocusNode();

  final viewModel = CreditNoteViewModel();
  double amountTobeUsedFromCreditNote = 0;
  var isLoadedOnce = false;
  String? errorMessage;
  late var width;
  late var height;
  late var selectedCreditNote;

  @override
  void initState() {
    super.initState();

    if (widget.sCreditNoteId != -1) {
      callCreditNoteApi(widget.sCreditNoteId.toString());
    }
  }

  callCreditNoteApi(String sValue) {
    viewModel.getCreditNotesDetails(sValue);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        height: height / 2,
        width: width / 2.8,
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
      widget.sCreditNoteId == -1
          ? MyTextFieldWidget(
              controller: numberController,
              node: numberNode,
              keyboardType: TextInputType.number,
              onSubmitted: (value) async {
                if (value.isNotEmpty) {
                  callCreditNoteApi(value);
                }
              },
              hint: "Enter credit note number",
            )
          : const SizedBox(),
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

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.sCreditNoteId == -1
              ? 'Select Credit Note'
              : 'Credit Note details',
          style: const TextStyle(
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

  Widget buttonAndCreditNoteDetails() {
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

    widgets.add(creditNoteWidget());

    return Column(children: widgets);
  }

  Widget validateAndGetCreditNote() {
    if (numberController.text.isEmpty && widget.sCreditNoteId == -1) {
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
                          Text(getReadableAmount(
                              getCurrency(),
                              selectedCreditNote.creditNote!.availableAmount -
                                  widget.removeAmount)),
                        ],
                      ),
                      SizedBox(
                        height: widget.removeAmount != 0.0 ? 10 : 0,
                      ),
                      widget.removeAmount != 0.0 ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Credit Note used amount :"),
                          Text(getReadableAmount(
                              getCurrency(),
                                  widget.removeAmount)),
                        ],
                      ):SizedBox(),
                    ],
                  ),
                  viewModel.isActive(selectedCreditNote)?
                  SizedBox(
                    width: 100,
                    height: 40,
                    child: MyOutlineButton(
                      text: widget.sCreditNoteId == -1 ? 'Save' : 'Remove',
                      onClick: widget.sCreditNoteId == -1 ? _save : _remove,
                    ),
                  ):
                      const SizedBox()
                ],
              ),
            ));
          } else if (selectedCreditNote!.creditNote.toString() == "null") {
            return const Text("This credit note number not exist ...");
          }
        }
        return Container();
      },
    );
  }

  void _save() {
      double due = 0.0;
      if(selectedCreditNote!=null) {
        if (widget.totalPayableAmount <
            double.parse(
                selectedCreditNote.creditNote!.availableAmount.toString())) {
          due = double.parse(
              selectedCreditNote.creditNote!.availableAmount.toString()) -
              widget.totalPayableAmount;
        }

        widget.saveCreditNote(
            selectedCreditNote.creditNote,
            double.parse(
                selectedCreditNote.creditNote!.availableAmount.toString()) -
                due,
            due);
        Navigator.of(context).pop();
      }
  }

  void _remove() {
    if(selectedCreditNote!=null) {
      widget.removeCreditNote(
          selectedCreditNote.creditNote, widget.removeAmount);
      Navigator.of(context).pop();
    }
  }
}
