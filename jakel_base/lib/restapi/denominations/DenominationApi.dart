import 'package:jakel_base/restapi/denominations/model/DenominationsResponse.dart';

abstract class DenominationApi {
  Future<DenominationsResponse> getDenominations();
}
