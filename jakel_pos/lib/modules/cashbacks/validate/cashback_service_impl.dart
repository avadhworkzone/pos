import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_pos/modules/cashbacks/validate/base_cashbacks.dart';
import 'package:jakel_pos/modules/cashbacks/validate/types/cashback_after_exclude_categories.dart';
import 'package:jakel_pos/modules/cashbacks/validate/types/cashback_after_exclude_none.dart';
import 'package:jakel_pos/modules/cashbacks/validate/types/cashback_after_exclude_products.dart';

import 'cashback_service.dart';

class CashBackServiceImpl with CashBackService {
  @override
  CartSummary applyCashbackForThisCart(
      CartSummary cartSummary, List<Cashbacks> allCashBacks) {
    // Iterate all cashback and check if its valid or not for this cart
    for (var value in allCashBacks) {
      BaseCashBacks? cashBack = getCashBack(value);

      if (cashBack != null && cashBack.isValidForThisCart(cartSummary, value)) {
        cartSummary.cashbackId = value.id;
        cartSummary.cashBackAmount = value.flatAmount;
        break;
      }
    }

    return cartSummary;
  }

  @override
  BaseCashBacks? getCashBack(Cashbacks cashback) {
    if (cashback.excludeByType == "PRODUCTS") {
      return CashBackAfterExcludeProducts();
    }

    if (cashback.excludeByType == "CATEGORIES") {
      return CashBackAfterExcludeCategories();
    }

    // Default None
    return CashBackAfterExcludeNone();
  }
}
