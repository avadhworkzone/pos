import 'package:internal_base/common/app_constants.dart';

class WebConstants {
  /// Standard Comparison Values
  static int statusCode200 = 200;
  static int statusCode400 = 400;
  static int statusCode422 = 422;

  static String statusMessageOK = "OK";
  static String statusMessageBadRequest = "Bad Request";
  static String statusMessageEntityError = "Unprocessable Entity Error";
  static String statusMessageTokenIsExpired = "Token is Expired";

  /// Web response cases
  static String statusCode200Message =
      "{  \"error\" : true,\n  \"statusCode\" : 200,\n  \"statusMessage\" : \"Success Request\",\n  \"data\" : {\"message\":\" Success \"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode403Message =
      "{  \"error\" : true,\n  \"statusCode\" : 403,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unauthorized error\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode404Message =
      "{  \"error\" : true,\n  \"statusCode\" : 404,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode412Message =
      "{  \"error\" : true,\n  \"statusCode\" : 412,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode422Message =
      "{  \"error\" : true,\n  \"statusCode\" : 412,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to find the action URL\"},\n  \"responseTime\" : 1639548038\n  }";
  static String statusCode502Message =
      "{\r\n  \"error\": true,\r\n  \"statusCode\": 502,\r\n  \"statusMessage\": \"Bad Request\",\r\n  \"data\": {\r\n    \"message\": \"Server Error, Please try after sometime\"\r\n  },\r\n  \"responseTime\": 1639548038\r\n}";
  static String statusCode503Message =
      "{  \"error\" : true,\n  \"statusCode\" : 503,\n  \"statusMessage\" : \"Bad Request\",\n  \"data\" : {\"message\":\"Unable to process your request right now, Please try again later\"},\n  \"responseTime\" : 1639548038\n  }";

  /// Control
  static String sGrantType = "password";

  ///posqa
  ///Promoter
  static String sClientId = "99b892e9-1b77-4473-9f01-82ff8dcc0cbd";
  static String sClientSecret = "RjWvUux5aiKpxCUUEyfLgs8LCZ5Ihi2s1QhfQ4Qm";
  static String sPromoterScope = "promoter_scope";

  ///WarehouseManager
  static String sWarehouseManagerClientSecret =
      "Y8vxAhYDaPzCOWr3a0FjUudLng6wtSRAO5nqMs9N";
  static String sWarehouseManagerClientId =
      "99b894bb-4c4a-48e3-b8fa-ed2cba830dbb";
  static String sWarehouseManagerScope = "warehouse_manager_scope";

  ///StoreManager
  static String sStoreManagerClientSecret =
      "Z3Fl774yZ76IAaN7mmU4HgTDGWpKQSlgJLZF03gk";
  static String sStoreManagerClientId = "99b8949b-ffc7-4c40-ba28-2267d4ddaf95";
  static String sStoreManagerScope = "store_manager_scope";

  ///dev
  // ///Promoter
  // static String sClientId = "996acfc5-1261-44d5-b444-d27fa8e4fd17";
  // static String sClientSecret = "v6rxbsZGShM7ZfDnB4n59vJroKv10RiOCd69iMmF";
  // static String sPromoterScope = "promoter_scope";
  //
  // ///WarehouseManager
  // static String sWarehouseManagerClientSecret =
  //     "mEhupOGkRodktBYEO66pIKk3L7thnppaFbWbz5WL";
  // static String sWarehouseManagerClientId =
  //     "996acabd-927e-48e7-8c20-a1d16243cac3";
  // static String sWarehouseManagerScope = "warehouse_manager_scope";
  //
  // ///StoreManager
  // static String sStoreManagerClientSecret =
  //     "7gXR0evJYrqDoaQTUzbV9I6JL7ND0jKHU3qGpePf";
  // static String sStoreManagerClientId = "996ac997-be51-488d-acb2-0f188ab456ad";
  // static String sStoreManagerScope = "store_manager_scope";

  ///Live
  ///Promoter
  // static String sClientId = "99ba60f1-741e-4f44-b496-c3be37fd4c24";
  // static String sClientSecret = "lP9xFidV5logjuIWf6iALXeCQQlOQ03Wz7Udmiu7";
  // static String sPromoterScope = "promoter_scope";

  // ///WarehouseManager
  // static String sWarehouseManagerClientSecret = "Xk3WJwFa2xpMaU6TD4VxL1qmay3SnL9lMw9C3L7O";
  // static String sWarehouseManagerClientId = "99ba612a-a2a3-4e6b-915f-bef513f8f7ee";
  //
  // static String sWarehouseManagerScope = "warehouse_manager_scope";
  //
  // ///StoreManager
  // static String sStoreManagerClientSecret =
  //     "GXs8i9K1RecljQTNdRENalO3ViG9vRVERCoHlbOa";
  // static String sStoreManagerClientId = "99ba6109-f615-48d3-a8a8-04a7d5ec6e82";
  // static String sStoreManagerScope = "store_manager_scope";
  //
  // static String sScope = "*";
  // static String privacyPolicy = "https://www.arianionline.my/privacy-policy?tokenid=ebc8b3175065e9a76ca4e18aebd38b10";

  /// Base URL
  static String baseUrlLive = "https://retail.ariani.my/";
  static String baseUrlDev = "https://posqa.freshbits.in/";

  // /// Base URL
  // static String baseUrlLive = "https://arianidevpos.freshbits.in/";
  // static String baseUrlDev = "https://arianidevpos.freshbits.in/";
  static String baseURL =
      AppConstants.isLiveURLToUse ? baseUrlLive : baseUrlDev;

  ///promoter api/promoter
  ///login
  static String actionPromoterLoginScreen = "${baseURL}api/promoter/get-token";

  ///Stores list
  static String actionGetPromoterStores = "${baseURL}api/promoter/get-stores";

  ///Profile details
  static String actionGetPromoteProfileDetails =
      "${baseURL}api/promoter/profile-details";

  ///profile-update
  static String actionPostPromoteProfileUpdate =
      "${baseURL}api/promoter/profile-update";

  ///dashboard details
  static String actionGetPromoterHome =
      "${baseURL}api/promoter/get-dashboard-data";

  ///promoter products
  static String actionGetPromoterProductsList =
      "${baseURL}api/promoter/promoter-products";

  ///promoter products Details ///get-product-details/66220/11
  static String actionGetPromoterProductsDetails =
      "${baseURL}api/promoter/get-product-details/";

  ///promoter products Stock List ////get-store-stock/1
  static String actionGetPromoterProductsStockList =
      "${baseURL}api/promoter/get-store-stock/";

  ///promoter commission list
  static String actionGetPromoterCommissionList =
      "${baseURL}api/promoter/get-promoter-commission-history";

  ///promoter sales & returns list
  static String actionGetPromoterSalesReturnsList =
      "${baseURL}api/promoter/get-sale-by-single-date";

  ///promoter commission Details ///get-promoter-commission-details/1617449
  static String actionGetPromoterCommissionDetails =
      "${baseURL}api/promoter/get-item-details/"; //get-promoter-commission-details/";

  ///add member
  static String actionAddMember = "${baseURL}api/promoter/save-member/";

  ///StoreManager api/store-manager
  ///login
  static String actionStoreManagerLoginScreen =
      "${baseURL}api/store-manager/get-token";

  ///Stores list
  static String actionGetStoreManagerStoresList =
      "${baseURL}api/store-manager/get-stores";

  /// products list
  static String actionGetStoreManagerProductsList =
      "${baseURL}api/store-manager/get-products";

  /// products Details
  static String actionGetStoreManagerProductsDetails =
      "${baseURL}api/store-manager/get-product-details/";

  /// products Stock List
  static String actionGetStoreManagerProductsStockList =
      "${baseURL}api/store-manager/get-store-stock/";

  ///dashboard details
  static String actionGetStoreManagerHome =
      "${baseURL}api/store-manager/get-dashboard-data";

  ///Profile details
  static String actionGetStoreManagerProfileDetails =
      "${baseURL}api/store-manager/profile-details";

  ///profile-update
  static String actionPostStoreManagerProfileUpdate =
      "${baseURL}api/store-manager/profile-update";

  ///sales list
  static String actionGetStoreManagerSalesList =
      "${baseURL}api/store-manager/sales";

  ///promoter list
  static String actionGetStoreManagerPromoterList =
      "${baseURL}api/store-manager/get-promoters";

  ///Warehouse Manager api/warehouse-manager
  ///login
  static String actionWarehouseManagerLoginScreen =
      "${baseURL}api/warehouse-manager/get-token";

  ///dashboard details
  static String actionGetWarehouseManagerHome =
      "${baseURL}api/warehouse-manager/get-dashboard-data";

  /// products list
  static String actionGetWarehouseManagerProductsList =
      "${baseURL}api/warehouse-manager/get-products";

  /// products Details
  static String actionGetWarehouseManagerProductsDetails =
      "${baseURL}api/warehouse-manager/get-product-details/";

  /// products Stock List
  static String actionGetWarehouseManagerProductsStockList =
      "${baseURL}api/warehouse-manager/get-store-stock/";

  ///Profile details
  static String actionGetWarehouseManagerProfileDetails =
      "${baseURL}api/warehouse-manager/profile-details";

  ///profile-update
  static String actionPostWarehouseManagerProfileUpdate =
      "${baseURL}api/warehouse-manager/profile-update";

  ///warehouses list
  static String actionGetWarehousesList =
      "${baseURL}api/warehouse-manager/get-warehouses";
}
