import 'package:jakel_base/restapi/sales/model/history/SaveSaleResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';

import '../restapi/sales/model/history/SalesResponse.dart';

bool isPendingLayawaySale(Sales sale) {
  if ((sale.status == "PENDING_LAYAWAY_SALE" ||
      sale.status == "COMPLETE_LAYAWAY_SALE") &&
      (sale.layawayPendingAmount ?? 0.0) > 0) {
    return true;
  }
  return false;
}

bool isLayawaySale(Sales sale) {
  if (sale.status == "PENDING_LAYAWAY_SALE" ||
      sale.status == "COMPLETE_LAYAWAY_SALE") {
    return true;
  }
  return false;
}

bool isLayawaySaleType(String? status) {
  if (status != null &&
      (status == "PENDING_LAYAWAY_SALE" || status == "COMPLETE_LAYAWAY_SALE")) {
    return true;
  }
  return false;
}

Sale getSaleFromSales(Sales sale) {
  return Sale.fromJson(sale.toJson());
}

Sales getSalesFromSale(Sale sale) {
  return Sales.fromJson(sale.toJson());
}

double getSubTotal(Sale sale) {
  double totalAmountPaid =
      (sale.totalAmountPaid ?? 0.0) + (sale.layawayPendingAmount ?? 0.0);
  double totalTax = (sale.totalTaxAmount ?? 0.0);
  double totalDiscount = (sale.totalDiscountAmount ?? 0.0);
  double saleRoundOffAmount = (sale.saleRoundOffAmount ?? 0.0);

  if (saleRoundOffAmount > 0) {
    return (totalAmountPaid +
        totalDiscount -
        (sale.saleRoundOffAmount ?? 0.0)) -
        totalTax;
  }

  // .abs() used to convert
  return (totalAmountPaid +
      totalDiscount +
      (sale.saleRoundOffAmount ?? 0.0).abs()) -
      totalTax;
}

double getTotalPaid(Sale sale) {
  if (isLayawaySaleType(sale.status)) {
    return ((sale.totalAmountPaid ?? 0));
  }
  return ((sale.totalAmountPaid ?? 0) + (sale.changeDue ?? 0));
}

double getTotalAmount(Sale sale) {
  return ((sale.totalAmountPaid ?? 0) + (sale.layawayPendingAmount ?? 0));
}

double getDiscountPercentFromAmount(double discountAmount,
    double originalAmount) {
  if (discountAmount <= 0) {
    return 0.0;
  }
  return getRoundedDoubleValue(discountAmount * 100 / originalAmount);
}

double getDiscountPercentFromNewAmount(double newPrice, double originalAmount) {
  return 100 - getRoundedDoubleValue(newPrice * 100 / originalAmount);
}

String getTotalQuantity(Sale sale) {
  double totalQty = 0;
  sale.saleItems?.forEach((element) {
    totalQty = totalQty + (element.quantity ?? 0);
  });
  return '${getInValue(totalQty)}';
}

String getTotalItems(Sale sale) {
  double totalItems = 0;
  List<String> alreadyAddedUpc = List.empty(growable: true);
  sale.saleItems?.forEach((element) {
    if (!alreadyAddedUpc.contains(element.product?.upc)) {
      totalItems = totalItems + 1;
      alreadyAddedUpc.add(element.product?.upc ?? "");
    }
  });
  return '${getInValue(totalItems)}';
}

String getTotalReturnItems(Sale sale) {
  double totalItems = 0;
  List<String> alreadyAddedUpc = List.empty(growable: true);
  sale.saleReturnItems?.forEach((element) {
    if (!alreadyAddedUpc.contains(element.product?.upc)) {
      totalItems = totalItems + 1;
      alreadyAddedUpc.add(element.product?.upc ?? "");
    }
  });
  return '${getInValue(totalItems)}';
}

String getTotalReturnQuantity(Sale sale) {
  double totalQty = 0;
  sale.saleReturnItems?.forEach((element) {
    totalQty = totalQty + (element.quantity ?? 0);
  });
  return '${getInValue(totalQty)}';
}

double getPricePerUnit(SaleItems saleItems) {
  if (saleItems.originalPricePerUnit != null &&
      saleItems.originalPricePerUnit! > 0) {
    return saleItems.originalPricePerUnit ?? 0;
  }

  if (saleItems.totalPricePaid != null) {
    return (saleItems.totalPricePaid ?? 0) / (saleItems.quantity ?? 0);
  }
  return 0;
}

double getTotalPricePaid(SaleItems saleItems) {
  num qty = getSaleItemQty(saleItems) ?? 0;

  if (qty > (saleItems.quantity ?? 0)) {
    if (saleItems.pricePaidPerUnit != null && saleItems.pricePaidPerUnit! > 0) {
      return (saleItems.pricePaidPerUnit ?? 0) * (qty ?? 1);
    }
  }

  if (saleItems.totalPricePaid != null && saleItems.totalPricePaid! > 0) {
    return saleItems.totalPricePaid ?? 0;
  }

  if (saleItems.pricePaidPerUnit != null && saleItems.pricePaidPerUnit! > 0) {
    return (saleItems.pricePaidPerUnit ?? 0) * (saleItems.quantity ?? 1);
  }

  return 0;
}

List<SaleItems> groupSaleItemAsPerArticle(List<SaleItems> items) {
  List<SaleItems> groupedItems = List.empty(growable: true);
  for (var item in items) {
    var addToGrouped = false;
    if (checkIfSameSaleArticleItem(groupedItems, item)) {
      addToGrouped = false;
      // Same article item exists in grouped item.
      // So we need to update that existing item with color or size in grouped item
    } else {
      // Set the initial item & color to list
      String colorSize = getColorSizeFromSaleItem(item);
      item.product?.setGroupedColorSize([colorSize]);
      addToGrouped = true;
    }

    // Add to grouped items
    if (addToGrouped) {
      groupedItems.add(item);
    }
  }

  return groupedItems;
}

String getColorSizeFromSaleItem(SaleItems item) {
  String colorSize = '';
  if (item.product?.size != null) {
    colorSize = '${item.product?.size?.name}';
  }
  if (item.product?.color != null) {
    if (colorSize.isEmpty) {
      colorSize = '${item.product?.color?.name}';
    } else {
      colorSize = '$colorSize-${item.product?.color?.name}';
    }
  }
  colorSize = '${getInValue(item.quantity)} x $colorSize';
  return colorSize;
}

// Article number, quantity & price should match
bool checkIfSameSaleArticleItem(List<SaleItems> items, SaleItems saleItem) {
  for (var element in items) {
    if (saleItem.product?.articleNumber == element.product?.articleNumber &&
        saleItem.product?.color?.name == element.product?.color?.name &&
        saleItem.product?.size?.name == element.product?.size?.name &&
        saleItem.originalPricePerUnit == element.originalPricePerUnit &&
        saleItem.totalPricePaid == element.totalPricePaid &&
        saleItem.quantity == element.quantity) {
      // Add size & color to the list
      String colorSize = getColorSizeFromSaleItem(saleItem);
      element.product?.groupedColorSize?.add(colorSize);
      return true;
    }
  }

  return false;
}

String? getSaleItemSizeColor(SaleItems item) {
  if (item.product == null ||
      item.product?.groupedColorSize == null ||
      item.product!.groupedColorSize!.isEmpty) {
    return null;
  }

  String colorSize = '';

  item.product?.groupedColorSize?.forEach((element) {
    if (element != null) {
      if (colorSize.isEmpty) {
        colorSize = element;
      } else {
        colorSize = '$colorSize\n$element';
      }
    }
  });

  if (colorSize.isEmpty) {
    return null;
  }

  return colorSize;
}

num? getSaleItemQty(SaleItems item) {
  if (item.product == null ||
      item.product?.groupedColorSize == null ||
      item.product!.groupedColorSize!.isEmpty) {
    return item.quantity;
  }

  return item.product!.groupedColorSize!.length * (item.quantity ?? 0);
  //return item.product?.groupedColorSize?.length ?? item.quantity;
}

bool isMoreThanOnePromoter(Sale sale) {
  List<int> alreadyAdded = List.empty(growable: true);
  sale.saleItems?.forEach((element) {
    element.promoters?.forEach((element) {
      if (!alreadyAdded.contains(element.id)) {
        alreadyAdded.add(element.id ?? 0);
      }
    });
  });

  return alreadyAdded.length > 1;
}

String getPromotersForItems(SaleItems saleItems) {
  String result = '';
  List<int> alreadyAdded = List.empty(growable: true);

  saleItems.promoters?.forEach((element) {
    if (alreadyAdded.contains(element.id)) {} else {
      if (result.isEmpty) {
        result = '${element.firstName}(${element.staffId ?? ''})';
      } else {
        result = '$result, ${element.firstName}(${element.staffId ?? ''})';
      }
      alreadyAdded.add(element.id ?? 0);
    }
  });

  return result;


  // String getPendingLayawayTotalDiscountAmount(Sales sale) {
  //   double totalPendingLayawayTax =
  //   getCalculatePendingLayawayTotalDiscountAmount(sale);
  //   return getReadableAmount("RM", totalPendingLayawayTax);
  // }

}

double getPendingLayawaySalesHistorySubTotal(Sale sale) {
  double totalAmountPaid =
      (sale.totalAmountPaid ?? 0.0) + (sale.layawayPendingAmount ?? 0.0);
  double totalTax = (sale.totalTaxAmount ?? 0.0);
  double totalDiscount = (sale.totalDiscountAmount ?? 0.0);
  double saleRoundOffAmount = (sale.saleRoundOffAmount ?? 0.0);
  double totalPendingLayawayTax =
  getCalculatePendingLayawayTotalDiscountAmount(sale);
  if (saleRoundOffAmount > 0) {
    return (totalAmountPaid + totalPendingLayawayTax +
        totalDiscount -
        (sale.saleRoundOffAmount ?? 0.0)) -
        totalTax;
  }

  // .abs() used to convert
  return (totalAmountPaid + totalPendingLayawayTax +
      totalDiscount +
      (sale.saleRoundOffAmount ?? 0.0).abs()) -
      totalTax;
}

double getCalculatePendingLayawayTotalDiscountAmount(Sale sale) {
  double totalPendingLayawayTax = 0.0;
  if ((sale.saleItems ?? []).isNotEmpty) {
    for (SaleItems mSaleItems in sale.saleItems ?? []) {
      totalPendingLayawayTax =
          totalPendingLayawayTax + (mSaleItems.totalDiscountAmount ?? 0.0);
    }
  }
  return totalPendingLayawayTax;
}
