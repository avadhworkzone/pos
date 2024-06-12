import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VouchersListResponse.dart';

import 'model/CashbacksResponse.dart';

abstract class CashBacksApi {
  Future<CashbacksResponse> getAllCashBacks();

}
