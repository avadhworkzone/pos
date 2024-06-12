import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

mixin PromotionsService {
  /// Select promotions from available promotions
  List<Promotions> selectAllValidCartWidePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions);

  /// Select promotions from available promotions
  List<Promotions> selectAllValidItemWisePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions);

  /// Select Item wise promotions from available promotions
  CartSummary pickBestItemWisePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions);

  /// Select CartWide promotions from available promotions
  CartSummary pickBestCartWidePromotions(
      CartSummary cartSummary, List<Promotions> allPromotions);

  /// Apply discount for specific promotion
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions);

  /// Check if the given promotions is item wise promotion
  bool isItemWisePromotion(Promotions promotions);

  /// Check if the given promotion is cart wide
  bool isCartWidePromotion(Promotions promotions);
}
