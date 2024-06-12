import 'package:jakel_base/database/sale/model/CartItemPrice.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';

cartItemSubTotalJob(CartSummary cartSummary) {
  double subTotal = 0.0;
  cartSummary.cartItems?.forEach((element) {
    // In Case New Item added for exchange, the price is retained from the exchanged item
    // in new_sale_widget _onProductSelected.
    if (element.isNewItemForExchange != true) {
      element.cartItemPrice = CartItemPrice();

      double productPrice = (element.product?.price ?? 0);
      double qty = element.qty ?? 1;

      // If open price item, set the open price as original price
      if (element.isOpenPriceItem()) {
        productPrice = element.openPrice ?? 0;
        element.cartItemPrice?.openPrice = productPrice;
      }

      MyLogUtils.logDebug("Cart Item In Sub  : ${element.toJson()}");
      MyLogUtils.logDebug(
          "Cart Item In Sub unitOfMeasures : ${element.unitOfMeasures?.toJson()}");
      MyLogUtils.logDebug(
          "Cart Item In Sub derivatives : ${element.derivatives?.toJson()}");
      // UOM product, update the price
      if (element.unitOfMeasures != null) {
        // These 2 fields are used while sending the sale to backend.
        element.cartItemPrice?.originalUomPrice = productPrice;
        element.uomQty = (1 / (element.derivatives?.ratio ?? 1)) * qty;
        productPrice = productPrice * (1 / (element.derivatives?.ratio ?? 1));
      }

      MyLogUtils.logDebug("Cart Item uomQty : ${element.uomQty}");
      MyLogUtils.logDebug("Cart Item productPrice : $productPrice");

      // In case of returns or exchange use the price that is already paid
      if (element.saleReturnsItemData != null) {
        productPrice =
            (element.saleReturnsItemData?.saleItem?.originalPricePerUnit ?? 0);
        qty = element.saleReturnsItemData?.qty ?? 1;
      }

      element.cartItemPrice?.setOriginalPrice(productPrice * qty);

      element.cartItemPrice?.setSubTotal(productPrice * qty);

      element.cartItemPrice?.setNextCalculationPrice(
          (element.cartItemPrice?.subTotal ?? 0) / qty);

      element.cartItemPrice
          ?.setTotalAmount(element.cartItemPrice?.subTotal ?? 0);
    }
    subTotal = subTotal + (element.cartItemPrice?.subTotal ?? 0);
  });
  return cartSummary;
}
