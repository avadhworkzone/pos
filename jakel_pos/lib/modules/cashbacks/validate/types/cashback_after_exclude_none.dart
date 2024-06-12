import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_pos/modules/cashbacks/validate/base_cashbacks.dart';

class CashBackAfterExcludeNone with BaseCashBacks {
  @override
  String title() {
    return "None of the products are excluded in this cashback";
  }

  @override
  String description() {
    return "None of the products are excluded in this cashback";
  }

  @override
  bool isValidForThisCart(CartSummary cartSummary, Cashbacks cashback) {
    if (cashback.minimumSpendAmount == null) {
      return false;
    }

    if ((cartSummary.cartPrice?.total ?? 0) >
        (cashback.minimumSpendAmount ?? 0)) {
      return true;
    }

    return false;
  }
}
