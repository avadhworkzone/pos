import 'package:jakel_base/database/sale/model/CartSummary.dart';

mixin VoucherService {
  /// Apply this voucher to the cart
  CartSummary applyVouchers(CartSummary cartSummary);
}
