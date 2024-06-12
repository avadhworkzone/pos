import 'package:flutter/cupertino.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/printer/types/print_refund_credit_notes.dart';
import 'package:jakel_base/restapi/counters/model/CreditNotesRefundRequest.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/CreditNotesApi.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesRefundResponce.dart';
import 'package:jakel_base/toast/my_toast.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';

class RefundCreditNoteViewModel extends BaseViewModel {
  /// credit Notes Refund
  bool isActive(CreditNotesApiResponse selectedCreditNote) {
    return selectedCreditNote.creditNote!.status.toString().toUpperCase() ==
        "ACTIVE";
  }

  Future<CreditNotesRefundResponse> creditNotesRefund(
      CreditNotesRefundRequest mCreditNotesRefundRequest,
      BuildContext context) async {
    var api = locator.get<CreditNotesApi>();
    try {
      var response = await api.getCreditNotesRefund(mCreditNotesRefundRequest);
      return response;
    } catch (e) {
      MyLogUtils.logDebug("getEmployees exception $e");
    }
    return CreditNotesRefundResponse();
  }
}
