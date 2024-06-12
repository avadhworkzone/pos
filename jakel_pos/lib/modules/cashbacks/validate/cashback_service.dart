import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_pos/modules/cashbacks/validate/base_cashbacks.dart';

import 'package:jakel_base/database/sale/model/CartSummary.dart';

mixin CashBackService {
  /// Apply this voucher to the cart
  CartSummary applyCashbackForThisCart(
      CartSummary cartSummary, List<Cashbacks> allCashBacks);

  // Factory to the cashback class
  BaseCashBacks? getCashBack(Cashbacks cashback);
}
