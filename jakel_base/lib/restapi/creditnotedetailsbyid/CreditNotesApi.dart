import 'package:jakel_base/restapi/counters/model/CreditNotesRefundRequest.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesListApiResponse.dart';
import 'package:jakel_base/restapi/creditnotedetailsbyid/model/CreditNotesRefundResponce.dart';

import 'model/CreditNotesApiResponse.dart';

abstract class CreditNotesApi {

  Future<CreditNotesListApiResponse> getCreditNotesList(int pageNo, int perPage,
      int customerId, int employeeId);

  Future<CreditNotesApiResponse> getCreditNotesDetails(
      String creditNotesDetailsByIdId);

  Future<CreditNotesRefundResponse> getCreditNotesRefund(
      CreditNotesRefundRequest mCreditNotesRefundRequest);

}
