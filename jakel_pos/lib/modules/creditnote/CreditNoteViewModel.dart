import 'package:jakel_base/constants.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/CreditNotesApi.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesApiResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesListApiResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class CreditNoteViewModel extends BaseViewModel {
  var responseSubject = PublishSubject<CreditNotesApiResponse>();

  Stream<CreditNotesApiResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  void getCreditNotesDetails(String number) async {
    var api = locator.get<CreditNotesApi>();

    try {
      var response = await api.getCreditNotesDetails(number);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getEmployees exception $e");
      responseSubject.sink.addError(e);
    }
  }

  bool isActive(CreditNotesApiResponse selectedCreditNote) {
    return selectedCreditNote.creditNote!.status
            .toString()
            .toLowerCase()
            .trim() ==
        "active";
  }

  ///

  var responseSubjectCreditNotesList =
      PublishSubject<CreditNotesListApiResponse>();

  Stream<CreditNotesListApiResponse> get responseStreamCreditNotesList =>
      responseSubjectCreditNotesList.stream;

  void closeObservableCreditNotesList() {
    responseSubjectCreditNotesList.close();
  }

  void getCreditNotesListByCustomerId(
      int pageNo, int perPage, int customerId, int employeeId) async {
    var api = locator.get<CreditNotesApi>();

    try {
      CreditNotesListApiResponse response =
          await api.getCreditNotesList(pageNo, perPage, customerId, employeeId);
      responseSubjectCreditNotesList.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getCreditNotesLis exception $e");
      responseSubjectCreditNotesList.sink.addError(e);
    }
  }

  String getCustomerName(CreditNotes sale) {
    return sale.userDetails?.firstName ?? noData;
  }

  String getCashier(CreditNotes sale) {
    return sale.cashier?.firstName ?? noData;
  }

  String getCounter(CreditNotes sale) {
    return sale.counter?.name ?? noData;
  }

  String getExpiryDateTime(CreditNotes sale) {
    return sale.expiryDate ?? noData;
  }

  String getTotalAmount(CreditNotes sale) {
    return getOnlyReadableAmount(sale.totalAmount ?? 0.0);
  }

  String getAvailableAmount(CreditNotes sale) {
    return getOnlyReadableAmount(sale.availableAmount ?? 0.0);
  }
}
