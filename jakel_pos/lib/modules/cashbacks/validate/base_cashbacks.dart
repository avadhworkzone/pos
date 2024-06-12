import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';

import 'package:jakel_base/database/sale/model/CartSummary.dart';

mixin BaseCashBacks {
  /// Title
  String title();

  /// Description explaining this type
  String description();

  /// Checks if this cashback configuration is valid for this particular cart
  /// Step 1: Remove return items from the cart.
  bool isValidForThisCart(CartSummary cartSummary, Cashbacks cashback);
}
