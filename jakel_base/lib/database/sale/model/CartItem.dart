import 'package:jakel_base/database/sale/model/CartItemDreamPriceData.dart';
import 'package:jakel_base/database/sale/model/CartItemFocData.dart';
import 'package:jakel_base/database/sale/model/CartItemPrice.dart';
import 'package:jakel_base/database/sale/model/CartItemPromotionItemData.dart';
import 'package:jakel_base/extension/ProductsDataExtension.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';
import 'package:jakel_base/restapi/promoters/model/PromotersResponse.dart';
import 'package:jakel_base/restapi/sales/model/NewSaleRequest.dart';
import 'package:jakel_base/utils/num_utils.dart';

import 'CartItemPriceOverrideData.dart';
import 'sale_returns_item_data.dart';

class CartItem {
  CartItemPrice? cartItemPrice;
  CartItemPriceOverrideData? cartItemPriceOverrideData;
  CartItemDreamPriceData? cartItemDreamPriceData;
  CartItemPromotionItemData? itemWisePromotionData;
  CartItemFocData? cartItemFocData;

  bool? isSelectItem = true;
  int? order = 0;
  Products? product;
  double? qty;

  // To be used only when its sent to the sale.
  // Because backend accepts the qty with respect to UOM.
  double? uomQty;
  UnitOfMeasures? unitOfMeasures;
  Derivatives? derivatives;
  double taxPercentage;
  List<Promoters>? promoters;
  bool? makeItGiftWithPurchase;

  String? batchNumber;
  List<BatchDetails>? batchDetails;

  // this is same the exchange item price while doing exchange.
  double? exchangePricePerUnit;

  //Enabled if this is the new item that is gonna be exchanged with old item
  bool? isNewItemForExchange;

  //Used for sale returns. Old item that is being exchanged or returned.
  SaleReturnsItemData? saleReturnsItemData;

  double? openPrice;

  CartItem({
    this.qty,
    this.uomQty,
    this.cartItemPrice,
    this.itemWisePromotionData,
    this.cartItemPriceOverrideData,
    this.cartItemDreamPriceData,
    this.cartItemFocData,
    this.isSelectItem = true,
    this.order,
    this.product,
    this.isNewItemForExchange,
    this.unitOfMeasures,
    this.derivatives,
    this.promoters,
    this.batchDetails,
    this.makeItGiftWithPurchase = false,
    this.taxPercentage = 0.0,
    this.openPrice,
    this.exchangePricePerUnit,
    this.batchNumber,
    this.saleReturnsItemData,
  });

  factory CartItem.fromJson(dynamic json) {
    return CartItem(
      product:
      json['product'] != null ? Products.fromJson(json['product']) : null,
      cartItemPrice: json['cartItemPrice'] != null
          ? CartItemPrice.fromJson(json['cartItemPrice'])
          : null,
      itemWisePromotionData: json['itemWisePromotionData'] != null
          ? CartItemPromotionItemData.fromJson(json['itemWisePromotionData'])
          : null,
      cartItemPriceOverrideData: json['cartItemPriceOverrideData'] != null
          ? CartItemPriceOverrideData.fromJson(
          json['cartItemPriceOverrideData'])
          : null,
      cartItemDreamPriceData: json['cartItemDreamPriceData'] != null
          ? CartItemDreamPriceData.fromJson(json['cartItemDreamPriceData'])
          : null,
      cartItemFocData: json['cartItemFocData'] != null
          ? CartItemFocData.fromJson(json['cartItemFocData'])
          : null,
      qty: getDoubleValue(json['qty']),
      uomQty: getDoubleValue(json['uomQty']),
      order: json['order'],
      isNewItemForExchange: json['isNewItemForExchange'],
      unitOfMeasures: json['unitOfMeasures'] != null
          ? UnitOfMeasures.fromJson(json['unitOfMeasures'])
          : null,
      derivatives: json['derivatives'] != null
          ? Derivatives.fromJson(json['derivatives'])
          : null,
      saleReturnsItemData: json['saleReturnsItemData'] != null
          ? SaleReturnsItemData.fromJson(json['saleReturnsItemData'])
          : null,
      taxPercentage: getDoubleValue(json['taxPercentage']),
      promoters: json['promoters'] != null
          ? (json['promoters'] as List)
          .map((i) => Promoters.fromJson(i))
          .toList()
          : [],
      batchDetails: json['batch_details'] != null
          ? (json['batch_details'] as List)
          .map((i) => BatchDetails.fromJson(i))
          .toList()
          : [],
      makeItGiftWithPurchase: json['makeItGiftWithPurchase'],
      openPrice: getDoubleValue(json['openPrice']),
      exchangePricePerUnit: getDoubleValue(json['exchangePricePerUnit']),
      batchNumber: json['batchNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    if (cartItemPrice != null) {
      data['cartItemPrice'] = cartItemPrice?.toJson();
    }

    if (cartItemPriceOverrideData != null) {
      data['cartItemPriceOverrideData'] = cartItemPriceOverrideData?.toJson();
    }

    if (cartItemDreamPriceData != null) {
      data['cartItemDreamPriceData'] = cartItemDreamPriceData?.toJson();
    }

    if (itemWisePromotionData != null) {
      data['itemWisePromotionData'] = itemWisePromotionData?.toJson();
    }

    if (cartItemFocData != null) {
      data['cartItemFocData'] = cartItemFocData?.toJson();
    }

    data['qty'] = qty;
    data['uomQty'] = uomQty;

    data['order'] = order;
    data['isNewItemForExchange'] = isNewItemForExchange;

    data['taxPercentage'] = taxPercentage;

    if (product != null) {
      data['product'] = product?.toJson();
    }

    if (unitOfMeasures != null) {
      data['unitOfMeasures'] = unitOfMeasures?.toJson();
    }

    if (derivatives != null) {
      data['derivatives'] = derivatives?.toJson();
    }

    if (saleReturnsItemData != null) {
      data['saleReturnsItemData'] = saleReturnsItemData?.toJson();
    }

    if (promoters != null) {
      data['promoters'] = promoters?.map((v) => v.toJson()).toList();
    }
    if (batchDetails != null) {
      data['batch_details'] = batchDetails?.map((v) => v.toJson()).toList();
    }
    data['makeItGiftWithPurchase'] = makeItGiftWithPurchase;

    data['openPrice'] = openPrice;

    if (exchangePricePerUnit != null) {
      data['exchangePricePerUnit'] = exchangePricePerUnit;
    }

    if (batchNumber != null) {
      data['batchNumber'] = batchNumber;
    }

    return data;
  }

  @override
  String toString() {
    return '${toJson()}';
  }

  double getDerivativeQty() {
    double value = getDoubleValue(qty);

    if ((uomQty ?? 0) > 0) {
      value = getDoubleValue(uomQty);
    }

    return value;
  }

  String getProductName() {
    if (saleReturnsItemData != null) {
      return saleReturnsItemData?.product?.name ?? "";
    }

    if (derivatives != null && derivatives!.name != null) {
      return "${product!.getProductName()} - ${derivatives!.name!}";
    }
    return product!.getProductName();
  }

  bool isOpenPriceItem() {
    if (product?.productType?.key != "REGULAR_PRODUCT") {
      return true;
    }
    return false;
  }

  /// Original price per unit.
  double getOriginalProductPrice() {
    if (saleReturnsItemData != null) {
      return saleReturnsItemData?.saleItem?.originalPricePerUnit ?? 0.0;
    }

    // Incase of UOM product, original price of UOM is kept.
    if ((cartItemPrice?.originalUomPrice ?? 0) > 0) {
      return (cartItemPrice?.originalUomPrice ?? 0);
    }

    return (cartItemPrice?.originalPrice ?? 0) / (qty ?? 1);
  }

  double getPricePaidPerUnitInReturns() {
    if (saleReturnsItemData != null) {
      double price = saleReturnsItemData?.saleItem?.pricePaidPerUnit ?? 0.0;
      return price;
    }
    return 0.0;
  }

  // This is used in price override to show actual price of the product
  double getProductPriceForPriceOverride() {
    return cartItemPrice?.priceToBeUsedForManualDiscount ??
        getOriginalProductPrice();
    // if (dreamPrice != null && dreamPrice! > 0) {
    //   return getDoubleValue(dreamPrice);
    // }
    // return getOriginalProductPrice();
  }

  double getProductPrice() {
    if (saleReturnsItemData != null) {
      return getOriginalProductPrice();
    }

    // Price override is done on top of dream price.
    // if price overrider is available, that should it be considered first
    // if (priceOverrideAmount != null &&
    //     priceOverrideAmount! > 0 &&
    //     getIsSelectItem()) {
    //   return getDoubleValue(priceOverrideAmount);
    // }

    // if (dreamPrice != null && dreamPrice! > 0 && getIsSelectItem()) {
    //   return getDoubleValue(dreamPrice);
    // }

    return getOriginalProductPrice();
  }

  // If dream price or over ride price is available,
  // then here that will be considered.But not automatic promotion.
  double getProductSubTotal() {
    if (saleReturnsItemData != null) {
      return -getDoubleValue((getDoubleValue((qty ?? 0) * getPerUnitPrice())));
    }
    return getDoubleValue((qty ?? 0) * getPerUnitPrice());
  }

  double getDiscountPercentFromFlat(double flatOfferAmount) {
    double itemPrice = cartItemPrice?.originalPrice ?? 0;
    double newPrice = getDoubleValue(itemPrice - flatOfferAmount);
    double discountPercent = 100 - (100 * newPrice) / itemPrice;
    return discountPercent;
  }

  // double getTotalPayablePrice() {
  //   return cartItemPrice?.totalAmount ?? 0;
  // }

  double getPerUnitPrice() {
    if (isNewItemForExchange != null &&
        isNewItemForExchange == true &&
        exchangePricePerUnit != null) {
      return exchangePricePerUnit ?? 0.0;
    }

    if (saleReturnsItemData != null) {
      return getProductPrice();
    }

    if (derivatives != null && derivatives!.ratio != null) {
      return getDoubleValue(getProductPrice() * (1 / derivatives!.ratio!));
    }
    return getProductPrice();
  }

  setIsSelectItem(bool isValue) {
    isSelectItem = isValue;
  }

  bool getIsSelectItem() {
    return isSelectItem ?? true;
  }

  bool checkIsSame(CartItem existingItem) {
    if (existingItem.isComplementaryItem()) {
      return false;
    }

    if (existingItem.saleReturnsItemData != null) {
      return false;
    }

    if (saleReturnsItemData != null) {
      return false;
    }

    if (existingItem.product?.id == product?.id) {
      //If both derivates is null, then its same product
      if (existingItem.derivatives == null && derivatives == null) {
        return true;
      }

      // If new item derivatives is not null && old item derivatives is null, its not same
      if (existingItem.derivatives != null && derivatives == null) {
        return false;
      }

      // If new item derivatives is  null && old item derivatives is not null, its not same
      if (existingItem.derivatives == null && derivatives != null) {
        return false;
      }

      if (existingItem.derivatives!.id == derivatives!.id) {
        return true;
      }
    }

    return false;
  }

  String getUniqueIdOfProduct() {
    String id = '${product?.id}';

    if (saleReturnsItemData != null) {
      id = '$id-${saleReturnsItemData?.saleItem?.id}';
    }

    if (derivatives != null) {
      id = '$id-${derivatives?.id}';
    }

    if (isComplementaryItem()) {
      id = '$id-FOC';
    }
    return id;
  }

  double getDiscountAmount() {
    if (saleReturnsItemData != null) {
      return (cartItemPrice?.totalDiscountAmount ?? 0);
    }

    return (cartItemPrice?.originalPrice ?? 0) -
        (cartItemPrice?.taxableAmount ?? 0);
  }

  bool isAvailableInGivenCategory(List<int> givenCategoryIds) {
    var result = false;
    product?.categories?.forEach((element) {
      if (givenCategoryIds.contains(element.id)) {
        result = true;
      }
    });
    return result;
  }

  bool isComplementaryItem() {
    if ((cartItemFocData?.complimentaryItemReasonId ?? 0) > 0) {
      return true;
    }
    return false;
  }

  bool isPriceOverrideApplied() {
    if (cartItemPriceOverrideData != null &&
        (cartItemPriceOverrideData?.priceOverrideAmount ?? 0) > 0) {
      return true;
    }
    return false;
  }

  double getTotalDiscountPercent() {
    if (!getIsSelectItem()) {
      return 0.0;
    }

    double originalPrice = cartItemPrice?.originalPrice ?? 0;

    if (saleReturnsItemData != null) {
      originalPrice =
          (saleReturnsItemData?.saleItem?.originalPricePerUnit ?? 0) *
              (saleReturnsItemData?.qty ?? 1);
    }
    double discountAmount = getTotalDiscountAmount();

    if (saleReturnsItemData != null) {
      double discountAmountPerUnit =
          (saleReturnsItemData?.saleItem?.totalDiscountAmount ?? 0) /
              (saleReturnsItemData?.saleItem?.quantity ?? 1);
      discountAmount = discountAmountPerUnit * (saleReturnsItemData?.qty ?? 1);
    }

    double discountPercent = (discountAmount * 100) / originalPrice;

    return discountPercent;
  }

  /// To Be Used Every Where
  double getTotalPaid() {
    return (cartItemPrice?.totalAmount ?? 0);
  }

  double getTotalDiscountAmount() {
    return ((cartItemPrice?.originalPrice ?? 0) -
        (cartItemPrice?.taxableAmount ?? 0));
  }

  bool allowDecimalQty() {
    if (unitOfMeasures?.allowDecimalQty == true) {
      return true;
    }
    return false;
  }
}
