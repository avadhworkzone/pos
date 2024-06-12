import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/database/promotions/PromotionsLocalApi.dart';
import 'package:jakel_base/database/promotions/promotion_types.dart';
import 'package:jakel_base/database/sale/model/CartSummary.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/promotions/model/PromotionsResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:jakel_pos/modules/promotions/validate/promotions_service.dart';
import 'package:rxdart/rxdart.dart';

import '../app_locator.dart';

class PromotionsViewModel extends BaseViewModel {
  List<Products> mProductList = [];

  List<Promotions> mPromotionsList = [];

  var responseSubject = PublishSubject<PromotionsResponse>();

  Stream<PromotionsResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  ///getPromotionsOffline() call from PromotionsList search or normal
  Future<void> getPromotionsOffline(String? sSearch) async {
    List<Promotions> mPromotionsSubList = [];
    try {
      if (mPromotionsList.isEmpty) {
        mPromotionsList = await getPromotions();
      }
      if (sSearch!.trim().isEmpty) {
        mPromotionsSubList.addAll(mPromotionsList);
      } else {
        mPromotionsSubList
            .addAll(await onSearchPromotions(sSearch.toLowerCase().trim()));
      }
      PromotionsResponse mPromotionsResponse = PromotionsResponse(
        promotions: mPromotionsSubList,
      );
      responseSubject.sink.add(mPromotionsResponse);
    } catch (e) {
      MyLogUtils.logDebug("getPromotions exception $e");
      responseSubject.sink.addError(e);
    }
  }

  ///get All Search Promotions List ( by promotions Name)
  Future<List<Promotions>> onSearchPromotions(String text) async {
    List<Promotions> mPromotionsSubList = [];
    for (var mPromotions in mPromotionsList) {
      if (promotionsName(mPromotions)
          .toLowerCase()
          .contains(text.toLowerCase())) {
        mPromotionsSubList.add(mPromotions);
      }
    }
    return mPromotionsSubList;
  }

  List<Promotions> filterItemWise(List<Promotions> allPromotions) {
    var api = appLocator.get<PromotionsService>();
    List<Promotions> itemWisePromotions = List.empty(growable: true);
    for (var value in allPromotions) {
      if (api.isItemWisePromotion(value)) {
        itemWisePromotions.add(value);
      }
    }
    return itemWisePromotions;
  }

  List<Promotions> filterCartWide(List<Promotions> allPromotions) {
    var api = appLocator.get<PromotionsService>();
    List<Promotions> itemWisePromotions = List.empty(growable: true);
    for (var value in allPromotions) {
      if (api.isCartWidePromotion(value)) {
        itemWisePromotions.add(value);
      }
    }
    return itemWisePromotions;
  }

  List<Promotions> getValidPromotionsForCart(
      CartSummary cartSummary, List<Promotions> allPromotions) {
    try {
      var api = appLocator.get<PromotionsService>();
      List<Promotions> allPromotions = List.empty(growable: true);
      List<Promotions> itemPromotions =
          api.selectAllValidItemWisePromotions(cartSummary, allPromotions);

      for (var element in itemPromotions) {
        allPromotions.add(element);
      }

      List<Promotions> cartPromotions =
          api.selectAllValidCartWidePromotions(cartSummary, allPromotions);

      for (var element in cartPromotions) {
        allPromotions.add(element);
      }

      MyLogUtils.logDebug("getValidPromotions allPromotions : $allPromotions");
      return allPromotions;
    } catch (e) {
      MyLogUtils.logDebug("getValidPromotions exception $e");
    }
    return [];
  }

  ///get All Promotions List ( Local database )
  Future<List<Promotions>> getPromotions() async {
    var api = locator.get<PromotionsLocalApi>();
    return await api.getAll();
  }

  ///get filter Promotions List by name( Local database )
  List<Promotions> filterPromotions(
      List<Promotions> promotions, String? searchText) {
    if (searchText == null || searchText.isEmpty) {
      return promotions;
    }
    List<Promotions> filtered = List.empty(growable: true);
    for (var element in promotions) {
      if (element.name!.toLowerCase().contains(searchText.toLowerCase())) {
        filtered.add(element);
      }
    }
    return filtered;
  }

  ///null value check
  String promotionsName(Promotions mPromotions) {
    return mPromotions.name ?? '';
  }

  String getName(Promotions promotions) {
    return (promotions.name ?? noData).replaceAll("_", " ");
  }

  String getPromotionApplicableType(Promotions promotions) {
    if (isCartWideDiscount(promotions)) {
      return "Cart widget";
    }

    if (isItemWiseDiscount(promotions)) {
      return "Item wise";
    }

    return noData;
  }

  String getPromotionType(Promotions promotions) {
    return (promotions.promotionType ?? noData).replaceAll("_", " ");
  }

  String getType(Promotions promotions) {
    if (promotions.promotionType == "CART_WIDE_AUTOMATIC_PERCENTAGE") {
      return "Percentage";
    }

    if (promotions.promotionType == "CART_WIDE_AUTOMATIC_FLAT") {
      return "Flat";
    }

    if (promotions.percentage != null && promotions.percentage! > 0) {
      return "Percentage";
    }
    if (promotions.flatAmount != null && promotions.flatAmount! > 0) {
      return "Flat";
    }

    return "Quantity";
  }

  String getTimeFrameLimit(Promotions promotions) {
    return promotions.timeframeType ?? noData;
  }

  bool showPaymentView(String sTitle) {
    if (sTitle.toString() == 'null' ||
        sTitle.toString() == '0' ||
        sTitle.toString() == '0.0') {
      return false;
    }
    return true;
  }

  ///get Product list from productId list
  Future<List<Products>> getProductListFromProductIds(
      List<int> productId) async {
    try {
      if (productId.isEmpty) {
        return mProductList;
      }
      if (mProductList.isEmpty) {
        var api = locator.get<ProductsLocalApi>();
        mProductList = await api.getAllProducts();
      }
      List<Products> uniqueItemsList = mProductList
          .toSet()
          .where((x) => productId.toSet().contains(x.id!))
          .toList();
      return uniqueItemsList;
    } catch (e) {
      MyLogUtils.logDebug("getProducts exception $e");
      responseSubject.sink.addError(e);
    }
    return mProductList;
  }

  ///  product nullable checking
  String season(Products products) {
    if (products.season != null) {
      return products.season!.name!;
    }
    return "";
  }

  String unitOfMeasure(Products products) {
    if (products.unitOfMeasure != null) {
      return products.unitOfMeasure!.name!;
    }
    return "";
  }

  String price(Products products) {
    return getOnlyReadableAmount(products.price ?? 0.0);
  }

  String getOnlyReadableAmount(dynamic amount) {
    double doubleAmount = 0.0;
    if (amount == null) {
      return doubleAmount.toStringAsFixed(2);
    }
    if (amount is int) {
      doubleAmount = double.parse("$amount");
    } else if (amount is String) {
      return amount;
    } else {
      doubleAmount = amount;
    }
    return doubleAmount.toStringAsFixed(2);
  }
}
