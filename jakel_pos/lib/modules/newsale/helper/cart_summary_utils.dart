import 'package:jakel_base/database/sale/model/CartSummary.dart';

double getTotalPayableAmountForManualCartDiscount(CartSummary cartSummary) {
  return cartSummary.cartPrice?.priceToBeUsedForManualDiscount ?? 0;
}
