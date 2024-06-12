import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/cashbacks/model/CashbacksResponse.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/restapi/vouchers/model/VoucherConfigurationResponse.dart';

import '../model/NewSaleConfiguration.dart';

mixin CartService {
  /// Get Updated cart summary.
  CartSummary getUpdatedCart(
      NewSaleConfiguration configuration,
      CartSummary cartSummary,
      List<DreamPrices> dreamPrices,
      List<Promotions> allPromotions,
      List<VoucherConfiguration> allVoucherConfigs,
      List<Cashbacks> allCashBacks);
}
