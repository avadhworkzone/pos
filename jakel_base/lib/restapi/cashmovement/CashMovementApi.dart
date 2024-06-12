import 'package:jakel_base/restapi/cashmovement/model/CashMovementReasonResponse.dart';
import 'package:jakel_base/restapi/cashmovement/model/CashMovementResponse.dart';

import '../../database/offlinedata/cashmovement/CashMovementRequest.dart';

abstract class CashMovementApi {
  Future<CashMovementReasonResponse> getCashMovementReasons();

  Future<CashMovementResponse> saveCashMovement(CashMovementRequest request);

  Future<CashMovementResponse> getAllCashMovements(
      int typeId, int pageNo, int perPage, bool onlyThisCounter);
}
