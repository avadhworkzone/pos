import 'package:flutter/material.dart';
import 'package:jakel_base/restapi/counters/model/CreditNotesRefundRequest.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesRefundResponce.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_base/widgets/custom/MyDataContainerWidget.dart';
import 'package:jakel_base/widgets/inkwell/my_ink_well_widget.dart';
import 'package:jakel_pos/modules/refundCreditNote/RefundCreditNoteViewModel.dart';
import 'package:jakel_pos/modules/refundCreditNote/ui/widgets/refund_manager_authorization_widget.dart';
import 'package:jakel_pos/modules/refundCreditNote/ui/widgets/refund_credit_note_widget.dart';

class RefundCreditNoteDialog extends StatefulWidget {
  final Function onSuccess;

  const RefundCreditNoteDialog({
    Key? key,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RefundCreditNoteDialogState();
  }
}

class _RefundCreditNoteDialogState extends State<RefundCreditNoteDialog> {
  CreditNote? selectedCreditNote;
  StoreManagers? selectedStoreManagers;
  var mRefundViewModel = RefundCreditNoteViewModel();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          width: 500,
          height: 400,
          child: MyDataContainerWidget(
            child: getNumbersWidget(),
          ),
        ));
  }

  Widget getNumbersWidget() {
    return Column(
      children: [
        getHeader(),
        const SizedBox(
          height: 10,
        ),
        const Divider(),
        const SizedBox(
          height: 10,
        ),
        Expanded(child: creditNoteView()),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget getHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Refund Credit Note in Cash',
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

  creditNoteView() {
    return RefundCreditNoteWidget(
      refundCreditNote: (CreditNote creditNote) {
        selectedCreditNote = creditNote;
        _refundManagerAuthorizationDialog();
      },
      mRefundViewModel: mRefundViewModel,
    );
  }

  Future<void> _refundManagerAuthorizationDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return RefundManagerAuthorizationWidget(
            onSuccess: (StoreManagers mStoreManagers) {
              showToast("Authorized to open cash drawer.", context);
              selectedStoreManagers = mStoreManagers;
              _refundApiCall();
            },
          );
        });
  }

  _refundApiCall() async {
    String sStoreManagersId = "";
    String sStoreManagersPasscode = "";
    if (selectedStoreManagers != null) {
      sStoreManagersId = selectedStoreManagers!.id.toString();
      sStoreManagersPasscode = selectedStoreManagers!.passcode.toString();
    }
    CreditNotesRefundResponse mCreditNotesRefundResponse =
        await mRefundViewModel.creditNotesRefund(
            CreditNotesRefundRequest(
              storeManagerId: sStoreManagersId,
              passcode: sStoreManagersPasscode,
              paymentTypeId: selectedCreditNote!.id.toString(),
              amount: selectedCreditNote!.availableAmount.toString(),
              refundPaymentTypeId: cashPaymentId.toString(),
            ),
            context);

    if (mCreditNotesRefundResponse.creditNote != null &&
        mCreditNotesRefundResponse.creditNote!.id != null) {
      widget.onSuccess(mCreditNotesRefundResponse.creditNote, sStoreManagersId);
    } else {
      Navigator.of(context).pop();
    }
  }
}
