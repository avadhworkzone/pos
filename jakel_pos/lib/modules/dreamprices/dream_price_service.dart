import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';

mixin DreamPriceService {
  /// Get all the available dream prices
  Future<List<DreamPrices>> getDreamPrices();

  /// Apply dream price to all the items.
  CartSummary applyDreamPrice(
      List<DreamPrices> dreamPrices, CartSummary cartSummary);

  /// Reset Applied Dream Prices
  CartSummary resetAppliedDreamPrice(CartSummary cartSummary);
}
