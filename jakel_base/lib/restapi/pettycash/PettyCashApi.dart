import 'package:jakel_base/restapi/pettycash/model/PettyCashUsageResponse.dart';

import 'model/PettyCashUsagesResponse.dart';

abstract class PettyCashApi {
  Future<PettyCashUsageResponse> getPettyCashUsageReasons();

  Future<bool> savePettyCash(int reasonId, double amount);

  Future<PettyCashUsagesResponse> getPettyCashUsages(
      int pageNo, int perPage, bool onlyThisCounter);
}
