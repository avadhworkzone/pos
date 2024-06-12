import 'package:jakel_base/database/dreamprice/DreamPriceLocalApi.dart';
import 'package:jakel_base/database/sale/model/CartItemDreamPriceData.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/dreamprice/model/DreamPriceResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_pos/modules/dreamprices/dream_price_helper.dart';
import 'package:jakel_pos/modules/dreamprices/dream_price_service.dart';

class DreamPriceServiceImpl with DreamPriceService {
  @override
  Future<List<DreamPrices>> getDreamPrices() async {
    var api = locator.get<DreamPriceLocalApi>();
    List<DreamPrices> dreamPrices = await api.getAll();
    return dreamPrices;
  }

  @override
  CartSummary applyDreamPrice(
      List<DreamPrices> dreamPrices, CartSummary cartSummary) {
    // Check & Add Valid dream price
    cartSummary.cartItems?.forEach((cartItem) {
      if (cartItem.getIsSelectItem()) {
        for (var dreamPrice in dreamPrices) {
          if (isDreamPriceValidForThisCart("DP", cartSummary, dreamPrice)) {
            MyLogUtils.logDebug(
                "isDreamPriceValidForThisCart for products :${dreamPrice.products} ");

            for (var product in dreamPrice.products!) {
              if (cartItem.product?.id == product.productId &&
                  product.price != null) {
                cartItem.cartItemDreamPriceData = CartItemDreamPriceData(
                    dreamPrice: getDoubleValue(product.price),
                    dreamPriceId: dreamPrice.id);

                // Set the price for next calculation
                cartItem.cartItemPrice
                    ?.setNextCalculationPrice(getDoubleValue(product.price));

                cartItem.cartItemPrice?.dreamPrice =
                    getDoubleValue(product.price);

                MyLogUtils.logDebug(
                    "DreamPrice : ${cartItem.cartItemDreamPriceData?.toJson()} for ${cartItem.getProductName()}");
                break;
              }
            }
          }
        }
      }
    });

    return cartSummary;
  }

  @override
  CartSummary resetAppliedDreamPrice(CartSummary cartSummary) {
    cartSummary.cartItems?.forEach((element) {
      element.cartItemDreamPriceData = null;
      element.cartItemPrice?.dreamPrice = null;
    });
    return cartSummary;
  }
}
