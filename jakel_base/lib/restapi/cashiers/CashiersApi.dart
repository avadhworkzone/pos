import 'package:jakel_base/restapi/cashiers/model/CashiersResponse.dart';

abstract class CashiersApi {
  Future<CashiersResponse> getCashiers();
}
