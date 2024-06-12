import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

mixin BaseVoucherConfig {
  /// Title of this voucher
  String title();

  /// Description explaining this type of voucher
  String description();

  /// Checks if this voucher configuration is valid for this particular cart
  /// Step 1: Remove return items from the cart.
  bool isValidForThisCart(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration);

  /// Get discount amount for the given cart
  double getVoucherAmount(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration);

  int getDiscountType();

  /// Create Voucher number
  String createVoucherNumber(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration);

  List<SaleVoucherConfigs>? getSaleVoucherConfig(
      CartSummary cartSummary, VoucherConfiguration voucherConfiguration);

  bool isBasicValidationPassed(CartSummary cartSummary) {
    if (cartSummary.employees == null) {
      return true;
    }
    return false;
  }
}
