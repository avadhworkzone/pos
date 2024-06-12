import 'package:jakel_base/database/sale/model/CartItem.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';

///All New discount Configuration should be created with BaseDiscount
//Multiple Discount applicable on the sale.
// ----------------------------------------------------
// 1) Complimentary Item
// 2) Price Override
// 3) Dream Price
// 4) Item Wise Promotion
// 5) Cart Wide promotion
// 6) Vouchers
// 7) Cashback
// This is the flow of discount application on the single sale.
mixin BasePromotion {
  /// Title of this discount
  String title();

  /// Description explaining this type of discount
  String description();

  /// Examples with products explaining this discount
  String samples();

  /// Check if this discount is  item discount
  bool isItemWise();

  /// Checks if this discount is cart wide discount
  bool isCardWide();

  /// Checks if this discount is valid for this particular cart
  /// Step 1: Remove return items from the cart.
  bool isValidDiscountForSale(CartSummary cartSummary, Promotions promotions);

  /// Get discount amount for the given cart
  double getDiscountAmount(CartSummary cartSummary, Promotions promotions);

  /// Apply this discount to the item
  List<CartItem> applyDiscount(CartSummary cartSummary, Promotions promotions);

  /// Check if item is valid For this Promotion
  bool isItemValidForPromotion(Promotions promotions, CartItem cartItem) {
    // If dream Price is applied for this item, its not eligible for promotion
    if (promotions.dreamPriceApplicable == false &&
        cartItem.cartItemDreamPriceData != null) {
      return false;
    }

    return cartItem.getIsSelectItem() &&
        cartItem.cartItemFocData == null &&
        (cartItem.isNewItemForExchange == null ||
            cartItem.isNewItemForExchange == false) &&
        (cartItem.saleReturnsItemData == null);
  }
}
