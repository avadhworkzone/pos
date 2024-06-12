import 'package:jakel_base/constants.dart';
import 'package:jakel_base/database/counter/CounterLocalApi.dart';
import 'package:jakel_base/database/products/ProductsLocalApi.dart';
import 'package:jakel_base/database/sale/model/ProductsData.dart';
import 'package:jakel_base/database/sale/model/sale_returns_item_data.dart';
import 'package:jakel_base/database/unitofmeasures/UnitOfMeasureLocalApi.dart';
import 'package:jakel_base/locator.dart';
import 'package:jakel_base/restapi/products/ProductsApi.dart';
import 'package:jakel_base/restapi/products/model/ProductsResponse.dart';
import 'package:jakel_base/restapi/products/model/UnitOfMeasureResponse.dart';
import 'package:jakel_base/utils/MyLogUtils.dart';
import 'package:jakel_base/utils/num_utils.dart';
import 'package:jakel_base/viewmodel/BaseViewModel.dart';
import 'package:rxdart/rxdart.dart';

class ProductsViewModel extends BaseViewModel {
  List<Products> mProductsList = [];
  String sSearch = "";
  var responseSubject = PublishSubject<ProductsResponse>();

  Stream<ProductsResponse> get responseStream => responseSubject.stream;

  void closeObservable() {
    responseSubject.close();
  }

  ///get  Product list ( on line )
  void getProducts(int pageNo, int perPage) async {
    var api = locator.get<ProductsApi>();

    try {
      var response = await api.getProducts(pageNo, perPage);
      responseSubject.sink.add(response);
    } catch (e) {
      MyLogUtils.logDebug("getProducts exception $e");
      responseSubject.sink.addError(e);
    }
  }

  ///getProductsOffline() call from ProductsList search or normal
  Future<void> getProductsOffline(String? sSearch) async {
    List<Products> mProductsSubList = [];
    try {
      if (mProductsList.isEmpty) {
        mProductsList = await getAllProducts();
      }
      if (sSearch!.trim().isEmpty) {
        mProductsSubList.addAll(mProductsList);
      } else {
        mProductsSubList
            .addAll(await onSearchProducts(sSearch.toLowerCase().trim()));
      }

      ProductsResponse mProductsResponse = ProductsResponse(
        products: mProductsSubList,
      );
      responseSubject.sink.add(mProductsResponse);
    } catch (e) {
      MyLogUtils.logDebug("getProducts exception $e");
      responseSubject.sink.addError(e);
    }
  }

  ///get All Search Product List ( by product Name, product upc  product ean)
  Future<List<Products>> onSearchProducts(String text) async {
    List<Products> mProductsSubList = [];
    for (var mProducts in mProductsList) {
      if (productName(mProducts).toLowerCase().contains(text.toLowerCase()) ||
          upc(mProducts).toLowerCase().contains(text.toLowerCase()) ||
          ean(mProducts).toLowerCase().contains(text.toLowerCase())) {
        mProductsSubList.add(mProducts);
      }
    }
    return mProductsSubList;
  }

  ///get Product from Products list using productId
  Future<Products?> getProduct(int? productId) async {
    var api = locator.get<ProductsLocalApi>();

    try {
      if (productId == null) {
        return null;
      }
      var response = await api.productById(productId);
      return response;
    } catch (e) {
      MyLogUtils.logDebug("getProducts exception $e");
      responseSubject.sink.addError(e);
    }
    return null;
  }

  ///get Product batchNumbers from product
  String? getProductBatch(Products? product) {
    try {
      if (product == null) {
        return null;
      }

      if (product.batchNumbers == null || product.batchNumbers!.isEmpty) {
        return null;
      }

      return product.batchNumbers!.first.batchNumber;
    } catch (e) {
      MyLogUtils.logDebug("getProducts exception $e");
      responseSubject.sink.addError(e);
    }
    return null;
  }

  ///  product nullable checking
  String productName(Products products) {
    return products.name ?? '';
  }

  String productCode(Products products) {
    return products.code ?? '';
  }

  String unitOfMeasure(Products products) {
    if (products.unitOfMeasure != null) {
      return products.unitOfMeasure!.name!;
    }
    return "";
  }

  String season(Products products) {
    if (products.season != null) {
      return products.season!.name!;
    }
    return "";
  }

  String department(Products products) {
    if (products.department != null) {
      return products.department!.name!;
    }
    return "";
  }

  String subDepartment(Products products) {
    if (products.subDepartment != null) {
      return products.subDepartment!;
    }
    return "";
  }

  String articleNumber(Products products) {
    return products.articleNumber ?? '';
  }

  String upc(Products products) {
    return products.upc ?? '';
  }

  String ean(Products products) {
    return products.ean ?? '';
  }

  String color(Products products) {
    if (products.color != null) {
      return products.color!.name!;
    }
    return "";
  }

  String size(Products products) {
    if (products.size != null) {
      return products.size!.name!;
    }
    return "";
  }

  String brand(Products products) {
    if (products.brand != null) {
      return products.brand!.name!;
    }
    return "";
  }

  String style(Products products) {
    if (products.style != null) {
      return products.style!.name!;
    }
    return "";
  }

  String price(Products products) {
    return getOnlyReadableAmount(products.price ?? 0.0);
  }

  bool isUpcOrEanMatching(ProductsData product, String? searchText) {
    if (searchText == null) {
      return false;
    }

    if (product.product?.upc != null &&
        product.product?.upc?.toLowerCase() == searchText.toLowerCase()) {
      return true;
    }

    if (product.product?.ean != null &&
        product.product?.ean?.toLowerCase() == searchText.toLowerCase()) {
      return true;
    }

    return false;
  }

  ///get All Product List ( Local database )
  Future<List<Products>> getAllProducts() async {
    var productsLocalApi = locator.get<ProductsLocalApi>();
    return await productsLocalApi.getAllProducts();
  }

  Future<List<ProductsData>> filterList(
      List<Products>? allProducts, String? searchText) async {
    // Case: If no products, first get all products list
    if (allProducts == null) {
      var productsLocalApi = locator.get<ProductsLocalApi>();
      allProducts = await productsLocalApi.getAllProducts();
    }

    if (searchText != null && searchText.isNotEmpty) {
      String specificItemName = searchText;

      // 1. Split text using ,
      List<String> splitSearchText = searchText.split(",");

      MyLogUtils.logDebug("filterList splitSearchText : $splitSearchText");

      // 2. Get first in the split text for finding items.
      if (splitSearchText.isNotEmpty) {
        specificItemName = splitSearchText.first;
      }

      MyLogUtils.logDebug("filterList specificItemName : $specificItemName");

      List<Products> filteredList = List.from(allProducts
          .where((element) => isProductMatching(specificItemName, element)));

      String color = "";
      //3. If split has color which is 2nd item in list, assign color.
      if (splitSearchText.length > 1) {
        color = splitSearchText[1].trim();

        // Search result is empty, So use secodary search to find if anythign is matching
        if (filteredList.isEmpty) {
          filteredList = List.from(allProducts.where(
              (element) => secondaryProductMatch(specificItemName, element)));
        }

        MyLogUtils.logDebug("filterList color : $color");
        // Sort by color if color word matches
        //sortByColor(color, filteredList);
        filteredList = filterByColor(color, filteredList);
      }

      String size = "";
      //4. If split has color which is 2nd item in list, assign size.
      if (splitSearchText.length > 2) {
        size = splitSearchText[2].trim();

        // Search result is empty, So use secodary search to find if anythign is matching
        if (filteredList.isEmpty) {
          filteredList = List.from(allProducts.where(
              (element) => secondaryProductMatch(specificItemName, element)));
        }

        MyLogUtils.logDebug("filterList color : $size");
        // Sort by color if color word matches
        //sortByColor(color, filteredList);
        filteredList = filterBySize(size, filteredList);
      }

      return filterAsPerTheUnitsOfMeasure(filteredList);
    }

    return filterAsPerTheUnitsOfMeasure(allProducts);
  }

  bool isProductMatching(String searchText, Products element) {
    if ((element.name != null &&
            element.name!.toLowerCase().contains(searchText.toLowerCase())) ||
        (element.upc != null &&
            element.upc!.toLowerCase().contains(searchText.toLowerCase())) ||
        (element.ean != null &&
            element.ean!.toLowerCase().contains(searchText.toLowerCase())) ||
        (element.code != null &&
            element.code!.toLowerCase().contains(searchText.toLowerCase())) ||
        (element.ean != null &&
            element.ean!.toLowerCase().contains(searchText.toLowerCase())) ||
        (element.customSku != null &&
            element.customSku!
                .toLowerCase()
                .contains(searchText.toLowerCase()))) {
      return true;
    }

    return false;
  }

  bool isSizeMatching(String size, Products element) {
    if (element.size?.name != null) {
      if ((element.size?.name ?? noData)
          .toLowerCase()
          .contains(size.toLowerCase())) {
        return true;
        ;
      }
    }
    return false;
  }

  bool isColorMatching(String color, Products element) {
    if (element.color?.name != null) {
      if ((element.color?.name ?? noData)
          .toLowerCase()
          .contains(color.toLowerCase())) {
        return true;
        ;
      }
    }
    return false;
  }

  bool secondaryProductMatch(String searchText, Products element) {
    List<String> searched = searchText.split(' ');
    if (searched
            .where((search) => (element.name ?? noData)
                .toLowerCase()
                .contains(search.toLowerCase()))
            .isNotEmpty ||
        searched
            .where((search) => (element.upc ?? noData)
                .toLowerCase()
                .contains(search.toLowerCase()))
            .isNotEmpty ||
        searched
            .where((search) => (element.ean ?? noData)
                .toLowerCase()
                .contains(search.toLowerCase()))
            .isNotEmpty ||
        searched
            .where((search) => (element.code ?? noData)
                .toLowerCase()
                .contains(search.toLowerCase()))
            .isNotEmpty ||
        searched
            .where((search) => (element.customSku ?? noData)
                .toLowerCase()
                .contains(search.toLowerCase()))
            .isNotEmpty ||
        searched
            .where((search) => (element.articleNumber ?? noData)
                .toLowerCase()
                .contains(search.toLowerCase()))
            .isNotEmpty) {
      return true;
    }
    return false;
  }

  void sortByColor(String color, List<Products> filteredList) {
    if (color.isEmpty) {
      return;
    }
    filteredList.sort((a, b) {
      if (a.color?.name != null) {
        if ((a.color?.name ?? noData)
            .toLowerCase()
            .contains(color.toLowerCase())) {
          return -1;
        }
      }

      if (b.color?.name != null) {
        if ((b.color?.name ?? noData)
            .toLowerCase()
            .contains(color.toLowerCase())) {
          return 1;
        }
      }

      return 0;
    });
  }

  List<Products> filterBySize(String size, List<Products> filteredList) {
    if (size.isEmpty) {
      return filteredList;
    }

    List<Products> updatedFilterList = List.from(
        filteredList.where((element) => isSizeMatching(size, element)));

    return updatedFilterList;
  }

  List<Products> filterByColor(String color, List<Products> filteredList) {
    if (color.isEmpty) {
      return filteredList;
    }

    List<Products> updatedFilterList = List.from(
        filteredList.where((element) => isColorMatching(color, element)));

    return updatedFilterList;
  }

  Future<List<ProductsData>> filterAsPerTheUnitsOfMeasure(
      List<Products> allProducts) async {
    List<ProductsData> filteredList = List.empty(growable: true);
    var unitOfMeasureApi = locator.get<UnitOfMeasureLocalApi>();
    var counterLocalApi = locator.get<CounterLocalApi>();
    var store = await counterLocalApi.getStore();
    double taxPercentage = store?.salesTaxPercentage ?? 0.0;
    // Split products as per Units of measures
    for (var element in allProducts) {
      //By default add the item if even unit of measure is there.
      //Customer can buy in unit of measure as well
      ProductsData productsData = ProductsData();
      productsData.product = element;
      productsData.taxPercentage = taxPercentage;
      if(element.unitOfMeasure==null) {
        filteredList.add(productsData);
      }

      // If units of measures are there ,
      // then split as per the unit of measures and that as well as item
      if (element.unitOfMeasure != null) {
        UnitOfMeasures unitOfMeasure =
            await unitOfMeasureApi.getById(element.unitOfMeasure!.id!);
        // Add the first item with derivatives ratio as 1.
        ProductsData productsData = ProductsData();
        productsData.product = element;
        productsData.derivatives = Derivatives(id: 0, name: "", ratio: 1);
        productsData.unitOfMeasures = unitOfMeasure;
        productsData.taxPercentage = taxPercentage;
        filteredList.add(productsData);

        // Add other items with derivatives ratio
        if (unitOfMeasure.derivatives != null &&
            unitOfMeasure.derivatives!.isNotEmpty) {
          for (var derivative in unitOfMeasure.derivatives!) {
            ProductsData productsData = ProductsData();
            productsData.product = element;
            productsData.derivatives = derivative;
            productsData.unitOfMeasures = unitOfMeasure;
            productsData.taxPercentage = taxPercentage;
            filteredList.add(productsData);
          }
        }
      }
    }

    return filteredList;
  }

  bool isReturnAllowed(SaleReturnsItemData mSaleReturnsItemData) {
    MyLogUtils.logDebug(
        "widget.mSaleReturnsItemData.product?.productType : ${mSaleReturnsItemData.saleItem?.product?.productType}");
    if (mSaleReturnsItemData.saleItem?.product?.productType?.key != null &&
        mSaleReturnsItemData.saleItem?.product?.productType?.key !=
            "REGULAR_PRODUCT") {
      return false;
    }
    return true;
  }
}
