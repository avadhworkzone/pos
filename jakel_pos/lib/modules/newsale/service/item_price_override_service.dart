import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/directors/model/DirectorsResponse.dart';
import 'package:jakel_base/restapi/managers/model/StoreManagersResponse.dart';
import 'package:jakel_base/restapi/me/model/CurrentUserResponse.dart';
import 'package:jakel_base/restapi/priceoverridetypes/model/PriceOverrideTypesResponse.dart';

mixin ItemPriceOverrideService {
  /// Get Updated cart summary.
  double getPercentageAllowed(
      List<PriceOverrideTypes> priceOverrideTypes,
      CartItem cartItem,
      CartSummary cartSummary,
      Cashier? cashier,
      StoreManagers? storeManagers,
      Directors? directors);
}
